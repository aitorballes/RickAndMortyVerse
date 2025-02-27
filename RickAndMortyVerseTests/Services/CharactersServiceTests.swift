import XCTest
@testable import RickAndMortyVerse

class CharactersServiceTests: XCTestCase {
    
    var sut: CharactersService!
    var mockHttpService: MockHttpService!
    
    override func setUp() {
        super.setUp()
        mockHttpService = MockHttpService()
        sut = CharactersService(httpService: mockHttpService)
    }
    
    override func tearDown() {
        sut = nil
        mockHttpService = nil
        super.tearDown()
    }
    
    func testGetCharacters_Success() async throws {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        let characters = try await sut.getCharacters()
        XCTAssertNotNil(characters)
        XCTAssertEqual(characters.results?.first?.name, "Rick Sanchez")
    }
    
    func testGetCharacters_Failure() async throws {
        mockHttpService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        do {
            _ = try await sut.getCharacters()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCharacters_NetworkError() async throws {
        mockHttpService.mockError = NSError(domain: "NSURLErrorDomain", code: -1009, userInfo: nil)
        
        do {
            _ = try await sut.getCharacters()
            XCTFail("Expected a network error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testGetCharacters_ServerError() async throws {
        mockHttpService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        do {
            _ = try await sut.getCharacters()
            XCTFail("Expected a server error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCharacters_InvalidJson() async throws {
        let invalidJson = """
        {
          "info": {
            "count": 826,
            "pages": 42,
            "next": null,
            "prev": null
          },
          "results": [
            {
              "id": "invalid_id",
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1"                
              ],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }            
          ]
        }
        """
        mockHttpService.mockData = invalidJson.data(using: .utf8)
        
        do {
            _ = try await sut.getCharacters()
            XCTFail("Expected a parsing error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCharacters_ConcurrentRequests() async throws {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        async let characters1 = sut.getCharacters()
        async let characters2 = sut.getCharactersByPage(page: "2")
        
        let (result1, result2) = await (try? characters1, try? characters2)
        
        XCTAssertNotNil(result1)
        XCTAssertNotNil(result2)
    }
    
    func testGetCharacters_Timeout() async throws {
        mockHttpService.mockError = NSError(domain: "NSURLErrorDomain", code: -1001, userInfo: nil)
        
        do {
            _ = try await sut.getCharacters()
            XCTFail("Expected a timeout error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCharactersByPage_Success() async throws {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        let characters = try await sut.getCharactersByPage(page: "2")
        XCTAssertNotNil(characters)
        XCTAssertEqual(characters.results?.first?.name, "Rick Sanchez")
    }
    
    func testGetCharactersByPage_Failure() async throws {
        mockHttpService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        do {
            _ = try await sut.getCharactersByPage(page: "2")
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCharactersByPage_InvalidPage() async throws {
        mockHttpService.mockError = NSError(domain: "TestError", code: 404, userInfo: nil)
        
        do {
            _ = try await sut.getCharactersByPage(page: "999")
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCharactersByPage_NoMorePages() async throws {
        let json = """
        {
          "info": {
            "count": 826,
            "pages": 42,
            "next": null,
            "prev": null
          },
          "results": []
        }
        """
        mockHttpService.mockData = json.data(using: .utf8)
        
        let characters = try await sut.getCharactersByPage(page: "42")
        XCTAssertNotNil(characters)
        XCTAssertTrue(characters.results?.isEmpty ?? false)
    }
    
    func testGetCharactersByFilters_Success() async throws {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        let characters = try await sut.getCharactersByFilters(filter: .init(name: "", gender: .unknown, status: .unknown, species: .unknown))
        XCTAssertNotNil(characters)
        XCTAssertEqual(characters.results?.first?.name, "Rick Sanchez")
    }
    
    func testGetCharactersByFilters_Failure() async throws {
        mockHttpService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        do {
            _ = try await sut.getCharactersByFilters(filter: .init(name: "", gender: .unknown, status: .unknown, species: .unknown))
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCharactersByFilters_WithNameFilter() async throws {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        let characters = try await sut.getCharactersByFilters(filter: .init(name: "Rick", gender: .unknown, status: .unknown, species: .unknown))
        XCTAssertNotNil(characters)
        XCTAssertEqual(characters.results?.first?.name, "Rick Sanchez")
    }

    func testGetCharactersByFilters_WithStatusFilter() async throws {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        let characters = try await sut.getCharactersByFilters(filter: .init(name: "", gender: .unknown, status: .alive, species: .unknown))
        XCTAssertNotNil(characters)
        XCTAssertEqual(characters.results?.first?.status, .alive)
    }
    
    private func getMockedJson() -> String {
        """
        {
          "info": {
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character?page=2",
            "prev": null
          },
          "results": [
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1"                
              ],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }            
          ]
        }
        """
    }
}
