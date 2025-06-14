import CoreData
import Foundation
import Observation

@Observable
class CharacterDetailViewModel {    
    let character: CharacterModel
    let context: NSManagedObjectContext
    
    var isFavorite: Bool = false

    init(character: CharacterModel, context: NSManagedObjectContext) {
        self.character = character
        self.context = context

        checkIfFavorite()
    }
    
    

    func toogleFavorite() {
        if isFavorite {
            removeFromFavorites()
        } else {
            addToFavorites()
        }
        isFavorite.toggle()
    }

    private func checkIfFavorite() {
        let fetchRequest: NSFetchRequest<FavoriteCharacter> =
            FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)

        do {
            let results = try context.fetch(fetchRequest)
            isFavorite = !results.isEmpty
        } catch {
            print(
                "Error checking if character is favorite: \(error.localizedDescription)"
            )
        }

    }

    private func addToFavorites() {
        let favoriteCharacter = FavoriteCharacter(context: context)
        favoriteCharacter.id = Int32(character.id)
        favoriteCharacter.name = character.name
        favoriteCharacter.status = character.status.rawValue
        favoriteCharacter.species = character.species.rawValue
        favoriteCharacter.gender = character.gender.rawValue
        favoriteCharacter.image = character.image
        favoriteCharacter.created = character.created
        favoriteCharacter.origin = character.origin.name
        favoriteCharacter.location = character.location.name

        do {
            try context.save()
        } catch {
            print("Error saving favorite character: \(error)")
        }
    }

    private func removeFromFavorites() {
        let fetchRequest: NSFetchRequest<FavoriteCharacter> =
            FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let favoriteCharacter = results.first {
                context.delete(favoriteCharacter)
                try context.save()
            }
        } catch {
            print("Error removing favorite character: \(error)")
        }
    }
}
