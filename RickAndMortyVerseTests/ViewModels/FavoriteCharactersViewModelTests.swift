import XCTest
import CoreData
@testable import RickAndMortyVerse

final class FavoriteCharactersViewModelTests: XCTestCase {
    var viewModel: FavoriteCharactersViewModel!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "RickAndMortyVerse")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        mockContext = container.viewContext
        viewModel = FavoriteCharactersViewModel(context: mockContext)
    }
    
    override func tearDown() {
        viewModel = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testFetchFavorites() {
        let character = FavoriteCharacter(context: mockContext)
        character.name = "Test Character"
        
        do {
            try mockContext.save()
        } catch {
            XCTFail("Failed to save mock data: \(error)")
        }
        
        viewModel.fetchFavorites()
        
        XCTAssertEqual(viewModel.favoriteCharacters.count, 1)
        XCTAssertEqual(viewModel.favoriteCharacters.first?.name, "Test Character")
    }
    
    func testDeleteFavorite() {
        let character = FavoriteCharacter(context: mockContext)
        character.name = "Character to Delete"
        
        do {
            try mockContext.save()
        } catch {
            XCTFail("Failed to save mock data: \(error)")
        }
        
        viewModel.fetchFavorites()
        XCTAssertEqual(viewModel.favoriteCharacters.count, 1)
        
        viewModel.deleteFavorite(at: IndexSet(integer: 0))
        XCTAssertEqual(viewModel.favoriteCharacters.count, 0)
    }
}
