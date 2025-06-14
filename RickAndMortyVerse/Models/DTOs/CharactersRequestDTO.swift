import Foundation

struct CharactersRequestDTO: Codable {
    let info: InfoRequestDTO?
    let results: [CharacterModel]?
}


extension CharactersRequestDTO {
    func toModel() -> CharactersPagedModel {
        return .init(characters: results ?? [], nextUrl: info?.next)
    }        
}
