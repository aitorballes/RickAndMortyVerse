import Foundation

struct CharacterModel: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin, location: LocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
