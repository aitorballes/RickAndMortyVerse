import Foundation
import Observation

@Observable
class CharactersViewModel {
    private let charactersService: CharactersService
    
    init(charactersService: CharactersService = CharactersService()){
        self.charactersService = charactersService
    }
    
    var characters: [CharacterModel] = []
    var nextPage: String? 
    var isBusy: Bool = false
    
    func getCharacters() {
        isBusy = true
        charactersService.getCharacters { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self, let result = result else {
                    self?.isBusy = false
                    return
                }
                self.characters = result.results ?? []
                self.nextPage = result.info?.next
                self.isBusy = false
            }
        }
    }
    
    func getCharactersByPage(page: String) {
        isBusy = true
        charactersService.getCharactersByPage(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self, let result = result else {
                    self?.isBusy = false
                    return
                }
                self.characters.append(contentsOf: result.results ?? [])
                self.nextPage = result.info?.next
                self.isBusy = false
            }
        }
    }
    
    func getNextCharacters() {
        guard let page = nextPage, let pageNumber = page.extractPageNumber() else { return }
        getCharactersByPage(page: pageNumber)
    }
}
