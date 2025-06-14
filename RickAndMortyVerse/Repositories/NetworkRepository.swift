import Foundation

protocol DataRepository {
    func getCharacters() async throws ->  CharactersPagedModel
    func getCharactersByFilters(filter: CharacterFiltersModel) async throws ->  CharactersPagedModel
    func getNextCharacters(nextQuery: [URLQueryItem]) async throws -> CharactersPagedModel
}

struct NetworkRepository: DataRepository, NetworkInteractor {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getCharacters() async throws -> CharactersPagedModel {
        try await getData(from: .getCharacters, expecting: CharactersRequestDTO.self).toModel()
       
    }
    
    func getCharactersByFilters(filter: CharacterFiltersModel) async throws -> CharactersPagedModel {
        try await getData(from: .getCharactersByFilters(filter), expecting: CharactersRequestDTO.self).toModel()
    }
    
    func getNextCharacters(nextQuery: [URLQueryItem]) async throws -> CharactersPagedModel {
        try await getData(from: .getNextCharacters(queryItems: nextQuery), expecting: CharactersRequestDTO.self).toModel()
    }
}
    

