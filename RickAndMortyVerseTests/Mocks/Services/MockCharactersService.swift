import Foundation
@testable import RickAndMortyVerse

class MockCharactersService: CharactersService {
    var mockResult: CharactersRequestModel?

    override func getCharacters(completion: @escaping (CharactersRequestModel?) -> Void) {
        completion(mockResult)
    }

    override func getCharactersByPage(page: String, completion: @escaping (CharactersRequestModel?) -> Void) {
        completion(mockResult)
    }
}
