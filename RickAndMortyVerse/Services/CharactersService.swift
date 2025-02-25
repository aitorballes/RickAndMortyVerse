import Foundation

class CharactersService {   
    
    func getCharacters(completion: @escaping (CharactersRequestModel?) -> Void) {
        fetchCharacters(from: "character", completion: completion)
    }
    
    func getCharactersByPage(page: String, completion: @escaping (CharactersRequestModel?) -> Void) {
        fetchCharacters(from: "character?page=\(page)", completion: completion)
    }
    
    private func fetchCharacters(from endpoint: String, completion: @escaping (CharactersRequestModel?) -> Void) {
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
                let charactersModel = try jsonDecoder.decode(CharactersRequestModel.self, from: data)
                completion(charactersModel)
            } catch {
                print("Error decoding: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
