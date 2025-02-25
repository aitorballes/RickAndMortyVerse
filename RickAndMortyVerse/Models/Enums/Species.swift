import Foundation

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
    case humanoid = "Humanoid"
    case poopybuthole = "Poopybutthole"
    case mythologicalCreature = "Mythological Creature"
    case animal = "Animal"
    case robot = "Robot"
    case cronenberg = "Cronenberg"
    case disease = "Disease"
    case unknown = "unknown"
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Species(rawValue: rawValue) ?? .unknown
    }
}
