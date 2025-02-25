import Foundation

struct CharactersRequestModel: Codable {
    let info: InfoRequestModel?
    let results: [CharacterModel]?
}
