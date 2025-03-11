import XCTest
import CoreData
@testable import RickAndMortyVerse

final class CharacterDetailViewModelTests: XCTestCase {
    var viewModel: CharacterDetailViewModel!
    var context: NSManagedObjectContext!
    var character: CharacterModel!

    override func setUp() {
        super.setUp()
        
        let container = NSPersistentContainer(name: "RickAndMortyVerse")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Error loading in-memory store: \(error?.localizedDescription ?? "Unknown")")
        }
        context = container.viewContext
        
        character =  .init(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: .alien,
            type: "Type",
            gender: .unknown,
            origin: .init(
                name: "Location",
                url: "LocationUrl"
            ),
            location: .init(
                name: "Location",
                url: "LocationUrl"
            ),
            image: "image",
            episode: [],
            url: "url",
            created: ""
        )
        
        
        viewModel = CharacterDetailViewModel(character: character, context: context)
    }

    override func tearDown() {
        viewModel = nil
        character = nil
        context = nil
        super.tearDown()
    }

    func test_initialState_isNotFavorite() {
        XCTAssertFalse(viewModel.isFavorite, "Character should not be favorite initially")
    }

    func test_toggleFavorite_addsToFavorites() {
        viewModel.toogleFavorite()
        
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1, "Character should be added to favorites")
            XCTAssertTrue(viewModel.isFavorite, "isFavorite should be true after adding")
        } catch {
            XCTFail("Error fetching favorites: \(error)")
        }
    }

    func test_toggleFavorite_removesFromFavorites() {
        viewModel.toogleFavorite()
        viewModel.toogleFavorite()
        
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 0, "Character should be removed from favorites")
            XCTAssertFalse(viewModel.isFavorite, "isFavorite should be false after removal")
        } catch {
            XCTFail("Error fetching favorites: \(error)")
        }
    }

    func test_checkIfFavorite_whenCharacterIsFavorite() {
        let favoriteCharacter = FavoriteCharacter(context: context)
        favoriteCharacter.id = Int32(character.id)
        favoriteCharacter.name = character.name
        
        do {
            try context.save()
            viewModel = CharacterDetailViewModel(character: character, context: context)
            XCTAssertTrue(viewModel.isFavorite, "isFavorite should be true if character is already in favorites")
        } catch {
            XCTFail("Error saving favorite character: \(error)")
        }
    }
}
