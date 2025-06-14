@testable import RickAndMortyVerse
import Foundation

extension CharactersPagedModel {
   static func mock(characters: [CharacterModel], nextUrl: URL? = nil) -> CharactersPagedModel {
        CharactersPagedModel(characters: characters, nextUrl: nextUrl)
    }
}
            
        

