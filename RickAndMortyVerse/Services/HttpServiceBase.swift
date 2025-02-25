import Foundation

class HttpServiceBase {
    
    static let shared = HttpServiceBase()
    private let apiBaseUrl = "https://rickandmortyapi.com/api/"
    
    internal init() {}
    
    func get<T: Decodable>(from endpoint: String, completion: @escaping (T?) -> Void) {
        guard let url = URL(string: apiBaseUrl + endpoint) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let jsonDecoder = JSONDecoder()
            
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Data was nil")
                completion(nil)
                return
            }
            
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print("Error decoding: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
