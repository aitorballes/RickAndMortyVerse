import Foundation

struct CharacterModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin, location: LocationModel
    let image: URL
    let episode: [String]
    let url: URL
    let created: Date
}
