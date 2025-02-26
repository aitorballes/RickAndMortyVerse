import XCTest

@testable import RickAndMortyVerse

class CharactersViewModelTests: XCTestCase {

    var sut: CharactersViewModel!
    var mockCharactersService: MockCharactersService!

    override func setUp() {
        super.setUp()
        mockCharactersService = MockCharactersService()
        sut = CharactersViewModel(charactersService: mockCharactersService)
    }

    override func tearDown() {
        sut = nil
        mockCharactersService = nil
        super.tearDown()
    }

    func testGetCharacters_Success() {
        // Arrange
        let expectedCharacterName = "Rick Sanchez"
        let expectedNextPage =
            "https://rickandmortyapi.com/api/character?page=2"
        let mockResponse = getMockData(
            characterName: expectedCharacterName, nextPage: expectedNextPage)
        mockCharactersService.mockResult = mockResponse

        let expectation = self.expectation(description: "Characters loaded")

        // Act
        sut.getCharacters()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.isBusy)
            XCTAssertEqual(self.sut.characters.count, 2)
            XCTAssertEqual(
                self.sut.characters.first?.name, expectedCharacterName)
            XCTAssertEqual(self.sut.nextPage, expectedNextPage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetCharactersByPage_Success() {
        // Arrange
        let expectedCharacterName = "Rick Sanchez"
        let expectedNextPage =
            "https://rickandmortyapi.com/api/character?page=3"
        let mockResponse = getMockData(
            characterName: expectedCharacterName, nextPage: expectedNextPage)

        mockCharactersService.mockResult = mockResponse

        let expectation = self.expectation(
            description: "Characters by page loaded")

        // Act
        sut.getCharactersByPage(page: "2")

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.isBusy)
            XCTAssertEqual(self.sut.characters.count, 2)
            XCTAssertEqual(
                self.sut.characters.first?.name, expectedCharacterName)
            XCTAssertEqual(self.sut.nextPage, expectedNextPage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetNextCharacters_Success() {
        // Arrange
        let expectedNextPage =
            "https://rickandmortyapi.com/api/character?page=3"
        let mockResponse = getMockData(nextPage: expectedNextPage)
        mockCharactersService.mockResult = mockResponse

        sut.getCharacters()

        let expectation = self.expectation(
            description: "Next characters loaded")

        // Act
        sut.getNextCharacters()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.isBusy)
            XCTAssertEqual(self.sut.characters.count, 2)
            XCTAssertEqual(self.sut.nextPage, expectedNextPage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetCharacters_Failure() {
        // Arrange
        mockCharactersService.mockResult = nil

        let expectation = self.expectation(
            description: "Characters load failed")

        // Act
        sut.getCharacters()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.isBusy)
            XCTAssertTrue(self.sut.characters.isEmpty)
            XCTAssertNil(self.sut.nextPage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetCharactersByPage_Failure() {
        // Arrange
        mockCharactersService.mockResult = nil

        let expectation = self.expectation(
            description: "Characters by page load failed")

        // Act
        sut.getCharactersByPage(page: "2")

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.isBusy)
            XCTAssertTrue(self.sut.characters.isEmpty)
            XCTAssertNil(self.sut.nextPage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetNextCharacters_NoNextPage() {
        // Arrange
        sut.nextPage = nil

        let expectation = self.expectation(description: "No next page")

        // Act
        sut.getNextCharacters()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.isBusy)
            XCTAssertTrue(self.sut.characters.isEmpty)
            XCTAssertNil(self.sut.nextPage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testGetCharacters_IsBusyState() {
        // Arrange
        let mockResponse = getMockData()
        mockCharactersService.mockResult = mockResponse

        let expectation = self.expectation(description: "IsBusy state updated")

        // Act
        sut.getCharacters()

        // Assert
        XCTAssertTrue(self.sut.isBusy)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.isBusy)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    private func getMockData(characterName: String = "", nextPage: String = "")
        -> CharactersRequestModel
    {
        CharactersRequestModel(
            info: .init(
                count: 1,
                pages: 1,
                next: nextPage
            ),
            results: [
                .init(
                    id: 1,
                    name: characterName,
                    status: .alive,
                    species: .alien,
                    type: "Type",
                    gender: .unknown,
                    origin: .init(
                        name: "Location",
                        url: "LocationUrl"
                    ),
                    location: .init(
                        name: "Location",
                        url: "LocationUrl"
                    ),
                    image: "image",
                    episode: [],
                    url: "url",
                    created: ""
                ),
                .init(
                    id: 2,
                    name: "Name",
                    status: .alive,
                    species: .alien,
                    type: "Type",
                    gender: .unknown,
                    origin: .init(
                        name: "Location",
                        url: "LocationUrl"
                    ),
                    location: .init(
                        name: "Location",
                        url: "LocationUrl"
                    ),
                    image: "image",
                    episode: [],
                    url: "url",
                    created: ""
                ),

            ]
        )
    }
}
