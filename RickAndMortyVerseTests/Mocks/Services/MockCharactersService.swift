import Foundation
@testable import RickAndMortyVerse

class MockCharactersService: CharactersService {
    var mockResult: CharactersRequestModel?
    var mockError: Error?
    
    override func getCharacters() async throws -> CharactersRequestModel {
        if let error = mockError {
            throw error
        }
        return mockResult ?? CharactersRequestModel(info: nil, results: [])
    }
    
    override func getCharactersByPage(page: String) async throws -> CharactersRequestModel {
        if let error = mockError {
            throw error
        }
        return mockResult ?? CharactersRequestModel(info: nil, results: [])
    }
    
    override func getCharactersByFilters(filter: CharacterFiltersModel) async throws -> CharactersRequestModel {
        if let error = mockError{
            throw error
        }
        return mockResult ?? CharactersRequestModel(info: nil, results: [])
    }
}
