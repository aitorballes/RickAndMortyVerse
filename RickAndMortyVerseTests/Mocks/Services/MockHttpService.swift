import Foundation
@testable import RickAndMortyVerse

class MockHttpService: HttpServiceBase {
    
    var mockData: Data?
    var mockError: Error?
    
    override func get<T: Decodable>(from endpoint: String, completion: @escaping (T?) -> Void) {
        if let error = mockError {
            print(error)
            completion(nil)
            return
        }
        
        guard let data = mockData else {
            print("Data was nil")
            completion(nil)
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(decodedData)
        } catch {
            print("Error decoding: \(error)")
            completion(nil)
        }
    }
}
