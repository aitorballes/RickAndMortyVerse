@testable import RickAndMortyVerse
import Foundation

extension CharacterModel {
    static func mock(id: Int, name: String) -> CharacterModel {
        return .init(
            id: id,
            name: name,
            status: .alive,
            species: .human,
            type: "",
            gender: .male,
            origin: LocationModel(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
            location: LocationModel(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
            image: URL(string: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg")!,
            episode: ["https://rickandmortyapi.com/api/episode/1"],
            url: URL(string: "https://rickandmortyapi.com/api/character/\(id)")!,
            created: Date(timeIntervalSince1970: 0)
        )
    }
        
}
