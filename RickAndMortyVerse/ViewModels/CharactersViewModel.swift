import Foundation
import Observation

@Observable
class CharactersViewModel {
    private let charactersService = CharactersService()
    
    var characters: [CharacterModel] = []
    var nextPage: String?
    
    func getCharacters() {
        charactersService.getCharacters { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self, let result = result else { return }
                self.characters = result.results ?? []
                self.nextPage = result.info?.next
            }
        }
    }
    
    func getCharactersByPage(page: String) {
        charactersService.getCharactersByPage(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self, let result = result else { return }
                self.characters.append(contentsOf: result.results ?? [])
                self.nextPage = result.info?.next
            }
        }
    }
    
    func getNextCharacters() {
        guard let page = nextPage, let pageNumber = extractPageNumber(from: page) else { return }
        getCharactersByPage(page: pageNumber)
    }   
    
    private func extractPageNumber(from url: String) -> String? {
        let pattern = "\\?page=(\\d+)"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: url, range: NSRange(url.startIndex..., in: url)),
              let range = Range(match.range(at: 1), in: url) else { return nil }
        
        return String(url[range])
    }
}
