import Foundation

class CharactersService {

    private let httpService: HttpServiceBase

    init(httpService: HttpServiceBase = HttpServiceBase.shared) {
        self.httpService = httpService
    }

    func getCharacters() async throws -> CharactersRequestModel {
        return try await httpService.get(from: "character")
    }

    func getCharactersByPage(page: String) async throws -> CharactersRequestModel {
        return try await httpService.get(from: "character?page=\(page)")
    }
    
    func getCharactersByFilters(filter: CharacterFiltersModel) async throws -> CharactersRequestModel {
        let queryString = generateQueryString(from: filter)
        return try await httpService.get(from: "character\(queryString)")
    }
    
    private func generateQueryString(from filters: CharacterFiltersModel) -> String {
        var queryItems: [String] = []
        
        if let name = filters.name {
            queryItems.append("name=\(name)")
        }
        if let gender = filters.gender {
            queryItems.append("gender=\(gender)")
        }
        if let status = filters.status {
            queryItems.append("status=\(status)")
        }
        if let species = filters.species {
            queryItems.append("species=\(species)")
        }
        
        return queryItems.isEmpty ? "" : "?" + queryItems.joined(separator: "&")
    }
}
