import Foundation

struct CharactersPagedModel: Codable {
    let characters: [CharacterModel]
    let nextUrl: URL?
}
