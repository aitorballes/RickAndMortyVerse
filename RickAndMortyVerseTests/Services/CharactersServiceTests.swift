import XCTest
@testable import RickAndMortyVerse

class CharactersServiceTests: XCTestCase {
    
    var sut: CharactersService!
    var mockHttpService: MockHttpService!
    
    override func setUp() {
        super.setUp()
        mockHttpService = MockHttpService()
        sut = CharactersService(httpService: mockHttpService) // Inyectamos el mock
    }
    
    override func tearDown() {
        sut = nil
        mockHttpService = nil
        super.tearDown()
    }
    
    func testGetCharacters_Success() {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        let expectation = self.expectation(description: "Fetch characters successfully")
        
        sut.getCharacters { characters in
            XCTAssertNotNil(characters)
            XCTAssertEqual(characters?.results?.first?.name, "Rick Sanchez")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCharacters_Failure() {
        mockHttpService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        let expectation = self.expectation(description: "Fetch characters with error")
        
        sut.getCharacters { characters in
            XCTAssertNil(characters)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCharactersByPage_Success() {
        let json = getMockedJson()
        mockHttpService.mockData = json.data(using: .utf8)
        
        let expectation = self.expectation(description: "Fetch characters by page successfully")
        
        sut.getCharactersByPage(page: "2") { characters in
            XCTAssertNotNil(characters)
            XCTAssertEqual(characters?.results?.first?.name, "Rick Sanchez")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCharactersByPage_Failure() {
        mockHttpService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        let expectation = self.expectation(description: "Fetch characters by page with error")
        
        sut.getCharactersByPage(page: "2") { characters in
            XCTAssertNil(characters)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
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
