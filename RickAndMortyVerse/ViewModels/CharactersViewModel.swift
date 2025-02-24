import Foundation
import Observation

@Observable
class CharactersViewModel {
    let charactersService = CharactersService()
    
    var characters: [CharacterModel]? = nil
    
    func getAllCharacters() {
        charactersService.getAllCharacters { [weak self] result in
            DispatchQueue.main.async {
                self?.characters = result?.results
            }
            
        }
    }
}
