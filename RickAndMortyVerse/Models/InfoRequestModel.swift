import Foundation

struct InfoRequestModel: Codable {
    let count, pages: Int
    let next: String?
}
