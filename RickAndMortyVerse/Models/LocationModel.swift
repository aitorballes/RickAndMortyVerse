import Foundation

struct LocationModel: Codable, Identifiable, Hashable {    
    let name: String
    let url: String
    
    var id: Self { self }
}
