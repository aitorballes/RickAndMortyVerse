import Foundation
class CharactersService {
    
    func getAllCharacters(completion: @escaping (CharactersRequestModel?) -> Void) {
        guard let url = URL(string:apiBaseUrl + "character") else{
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
                let proverbModel = try jsonDecoder.decode(CharactersRequestModel.self, from: data)
                completion(proverbModel)
            } catch {
                print("Error decoding: \(error)")
                completion(nil)
            }
        }

        task.resume()
        
    }
    
}

