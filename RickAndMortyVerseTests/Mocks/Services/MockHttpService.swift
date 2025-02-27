import Foundation
@testable import RickAndMortyVerse

class MockHttpService: HttpServiceBase {
    var mockData: Data?
    var mockError: Error?
    
    override func get<T: Decodable>(from endpoint: String) async throws -> T {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw URLError(.badServerResponse)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}
