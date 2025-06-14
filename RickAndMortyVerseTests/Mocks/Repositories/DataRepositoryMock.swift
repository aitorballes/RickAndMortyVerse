import Foundation
@testable import RickAndMortyVerse

final class DataRepositoryMock: DataRepository {
    var getCharactersResult: Result<CharactersPagedModel, Error>?
    var getCharactersByFiltersResult: Result<CharactersPagedModel, Error>?
    var getNextCharactersResult: Result<CharactersPagedModel, Error>?
    

    func getCharacters() async throws -> CharactersPagedModel {
        switch getCharactersResult {
        case .success(let models): return models
        case .failure(let error): throw error
        case .none: fatalError("charactersPagedResult not configured")
        }
    }
    
    func getCharactersByFilters(filter: CharacterFiltersModel) async throws -> CharactersPagedModel {
        switch getCharactersByFiltersResult {
        case .success(let models): return models
        case .failure(let error): throw error
        case .none: fatalError("charactersPagedResult not configured")
        }
    }
    
    func getNextCharacters(nextQuery: [URLQueryItem]) async throws -> CharactersPagedModel {
        switch getNextCharactersResult {
        case .success(let models): return models
        case .failure(let error): throw error
        case .none: fatalError("charactersPagedResult not configured")
        }
    }

}
