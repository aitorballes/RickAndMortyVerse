import Foundation

final class NetworkInteractorMock: URLProtocol {
    
    var urlCharacters: URL {
        Bundle.main.url(forResource: "characters", withExtension: "json")!
    }
    
    var urlNextCharacters: URL {
        Bundle.main.url(forResource: "nextCharacters", withExtension: "json")!
    }
    
    var urlFilteredCharacters: URL {
        Bundle.main.url(forResource: "charactersFilteredRickAlive", withExtension: "json")!
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        defer {
            client?.urlProtocolDidFinishLoading(self)
        }
        
        guard let url = request.url else { return }
        if url == URL(string: "https://rickandmortyapi.com/api/character")  {
            guard let data = try? Data(contentsOf: urlCharacters)
            else { return }

            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(
                self,
                didReceive: getSuccessResponseForUrl(url: url),
                cacheStoragePolicy: .notAllowed
            )
        }
        
        if url == URL(string: "https://rickandmortyapi.com/api/character?page=2") {
            guard let data = try? Data(contentsOf: urlNextCharacters)
            else { return }

            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(
                self,
                didReceive: getSuccessResponseForUrl(url: url),
                cacheStoragePolicy: .notAllowed
            )
        }
        
        if url == URL(string: "https://rickandmortyapi.com/api/character?name=Rick&status=Alive")  {
            guard let data = try? Data(contentsOf: urlFilteredCharacters)
            else { return }

            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(
                self,
                didReceive: getSuccessResponseForUrl(url: url),
                cacheStoragePolicy: .notAllowed
            )
        }
    }
    
    override func stopLoading() {
        // No additional cleanup needed for mock
    }
    
    private func getSuccessResponseForUrl(url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: [
                "Content-Type": "application/json;chatset=utf-8"
            ]
        )!
    }
    
}
