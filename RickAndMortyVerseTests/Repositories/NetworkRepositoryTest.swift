import XCTest
@testable import RickAndMortyVerse

final class NetworkRepositoryTests: XCTestCase {
    var network: NetworkRepository!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [NetworkInteractorMock.self]
        let session = URLSession(configuration: config)
        network = NetworkRepository(session: session)
    }
    
    override func tearDownWithError() throws {
        network = nil
    }
    
    func testGetCharacters() async throws {
        // Act
        let result = try await network.getCharacters()
        // Assert
        XCTAssertEqual(result.characters.count, 20, "Must return 20 characters")
        XCTAssertEqual(result.nextUrl, URL(string: "https://rickandmortyapi.com/api/character?page=2")!, "Must correct next URL")
    }
    
    func testGetNextCharacters() async throws {
        // Arrange
        let nextQuery = [URLQueryItem(name: "page", value: "2")]
        // Act
        let result = try await network.getNextCharacters(nextQuery: nextQuery)
        // Assert
        XCTAssertEqual(result.characters.count, 20, "Must return 20 characters")
        XCTAssertEqual(result.nextUrl, URL(string: "https://rickandmortyapi.com/api/character?page=3")!, "Must correct next URL")
    }
    
    func testGetCharactersByFilters() async throws {
        // Arrange
        let filters = CharacterFiltersModel(name: "Rick", gender: nil, status: .alive, species: nil)
        // Act
        let result = try await network.getCharactersByFilters(filter: filters)
        // Assert
        XCTAssertEqual(result.characters.count, 20, "Must return 20 characters")
        XCTAssertEqual(result.nextUrl, URL(string: "https://rickandmortyapi.com/api/character?page=2&name=rick&status=alive")!, "Must correct next URL")
    }
}
