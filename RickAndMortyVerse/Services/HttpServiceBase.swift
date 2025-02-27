import Foundation

class HttpServiceBase {
    
    static let shared = HttpServiceBase()
    private let apiBaseUrl = "https://rickandmortyapi.com/api/"
    
    internal init() {}
    
    func get<T: Decodable>(from endpoint: String) async throws -> T {
        guard let url = URL(string: apiBaseUrl + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(T.self, from: data)
    }
}
