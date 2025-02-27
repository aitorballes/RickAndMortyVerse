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

    func testGetCharacters_Success() async {
        let expectedCharacterName = "Rick Sanchez"
        let expectedNextPage = "https://rickandmortyapi.com/api/character?page=2"
        let mockResponse = getMockData(characterName: expectedCharacterName, nextPage: expectedNextPage)
        mockCharactersService.mockResult = mockResponse

        await sut.getCharacters()

        XCTAssertFalse(sut.isBusy)
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertEqual(sut.characters.first?.name, expectedCharacterName)
        XCTAssertEqual(sut.nextPage, expectedNextPage)
    }

    func testGetCharactersByPage_Success() async {
        let expectedCharacterName = "Rick Sanchez"
        let expectedNextPage = "https://rickandmortyapi.com/api/character?page=3"
        let mockResponse = getMockData(characterName: expectedCharacterName, nextPage: expectedNextPage)
        mockCharactersService.mockResult = mockResponse

        await sut.getCharactersByPage(page: "2")

        XCTAssertFalse(sut.isBusy)
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertEqual(sut.characters.first?.name, expectedCharacterName)
        XCTAssertEqual(sut.nextPage, expectedNextPage)
    }

    func testGetNextCharacters_Success() async {
        let expectedNextPage = "https://rickandmortyapi.com/api/character?page=3"
        let mockResponse = getMockData(nextPage: expectedNextPage)
        mockCharactersService.mockResult = mockResponse

        await sut.getCharacters()
        await sut.getNextCharacters()

        XCTAssertFalse(sut.isBusy)
        XCTAssertEqual(sut.characters.count, 4)
        XCTAssertEqual(sut.nextPage, expectedNextPage)
    }

    func testGetCharacters_Failure() async {
        mockCharactersService.mockResult = nil

        await sut.getCharacters()

        XCTAssertFalse(sut.isBusy)
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertNil(sut.nextPage)
    }

    func testGetCharactersByPage_Failure() async {
        mockCharactersService.mockResult = nil

        await sut.getCharactersByPage(page: "2")

        XCTAssertFalse(sut.isBusy)
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertNil(sut.nextPage)
    }

    func testGetNextCharacters_NoNextPage() async {
        sut.nextPage = nil

        await sut.getNextCharacters()

        XCTAssertFalse(sut.isBusy)
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertNil(sut.nextPage)
    }

    func testGetCharacters_IsBusyState() async {
        let mockResponse = getMockData()
        mockCharactersService.mockResult = mockResponse

        await sut.getCharacters()

        XCTAssertFalse(sut.isBusy)
    }
    
    func testApplyFilters_Success() async {
        let expectedCharacterName = "Filtered Rick"
        let mockResponse = getMockData(characterName: expectedCharacterName)
        mockCharactersService.mockResult = mockResponse

        await sut.applyFilters(searchText: "Rick", gender: .male, status: .alive, species: .human)

        XCTAssertFalse(sut.isBusy)
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertEqual(sut.characters.first?.name, expectedCharacterName)
    }

    func testApplyFilters_NoResults() async {
        mockCharactersService.mockResult = CharactersRequestModel(info: nil, results: [])

        await sut.applyFilters(searchText: "Unknown", gender: nil, status: nil, species: nil)

        XCTAssertFalse(sut.isBusy)
        XCTAssertTrue(sut.characters.isEmpty)
    }

    func testApplyFilters_Failure() async {
        mockCharactersService.mockResult = nil

        await sut.applyFilters(searchText: "Rick", gender: .male, status: .alive, species: .human)

        XCTAssertFalse(sut.isBusy)
        XCTAssertTrue(sut.characters.isEmpty)
    }
    
    func testExtractPageNumber() {
        let url = "https://rickandmortyapi.com/api/character?page=2"
        let pageNumber = url.extractPageNumber()
        XCTAssertEqual(pageNumber, "2")
    }


    private func getMockData(characterName: String = "", nextPage: String = "")
        -> CharactersRequestModel
    {
        return CharactersRequestModel(
            info: .init(count: 1, pages: 1, next: nextPage),
            results: [
                .init(
                    id: 1, name: characterName, status: .alive, species: .alien,
                    type: "Type", gender: .unknown,
                    origin: .init(name: "Location", url: "LocationUrl"),
                    location: .init(name: "Location", url: "LocationUrl"),
                    image: "image", episode: [], url: "url", created: ""),
                .init(
                    id: 2, name: "Name", status: .alive, species: .alien,
                    type: "Type", gender: .unknown,
                    origin: .init(name: "Location", url: "LocationUrl"),
                    location: .init(name: "Location", url: "LocationUrl"),
                    image: "image", episode: [], url: "url", created: ""),
            ]
        )
    }
}
