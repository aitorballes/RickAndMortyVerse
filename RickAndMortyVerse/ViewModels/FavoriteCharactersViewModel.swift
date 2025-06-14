import Foundation
import CoreData
import Observation

@Observable
class FavoriteCharactersViewModel {
    var favoriteCharacters: [FavoriteCharacter] = []
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context        
    }
    
    func fetchFavorites() {
        let request: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        do {
            favoriteCharacters = try context.fetch(request)
        } catch {
            print("Error fetching favorite characters: \(error)")
        }
    }
    
    func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let character = favoriteCharacters[index]
            context.delete(character)
        }
        do {
            try context.save()
            fetchFavorites()
        } catch {
            print("Error deleting favorite character: \(error)")
        }
    }
    
    
}
