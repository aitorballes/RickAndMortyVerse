import Foundation

extension URL {
    private static let apiBaseUrl = URL(string: "https://rickandmortyapi.com/api/")!
    
    static let getCharacters = apiBaseUrl.appending(path: "character")
    
    static func getCharactersByFilters(_ filters: CharacterFiltersModel) -> URL {
         getCharacters.appending(queryItems: URLQueryItem.queryItemsByFilters(filters))
    }
    
    static func getNextCharacters(queryItems: [URLQueryItem]) -> URL {    
              
        getCharacters.appending(queryItems: queryItems)
    }
}

extension URL {
    func getQueryItems() -> [URLQueryItem] {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        return components?.queryItems ?? []
    }
}
