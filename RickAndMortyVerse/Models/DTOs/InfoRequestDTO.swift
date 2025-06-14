import Foundation

struct InfoRequestDTO: Codable {
    let count, pages: Int
    let next: URL?
}
