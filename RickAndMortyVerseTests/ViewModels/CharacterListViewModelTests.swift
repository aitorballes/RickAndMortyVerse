import XCTest
@testable import RickAndMortyVerse

final class CharacterListViewModelTests: XCTestCase {
    
    var mockRepository: DataRepositoryMock!
    var viewModel: CharacterListViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = DataRepositoryMock()
        
    }
    
    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialFetchCharactersSuccess() async {
        //Arrange
        let character = CharacterModel.mock(id: 1, name: "Rick Sanchez")
        let nextUrl = URL(string: "https://api.example.com?page=2")
        mockRepository.getCharactersResult = .success(CharactersPagedModel.mock(characters: [character], nextUrl: nextUrl))
        viewModel = CharacterListViewModel(repository: mockRepository)
        
        //Act
        await viewModel.getCharacters()
        
        //Assert
        XCTAssertEqual(viewModel.characters, [character])
        XCTAssertEqual(viewModel.queryItems, nextUrl?.getQueryItems() ?? [])
        XCTAssertFalse(viewModel.isBusy)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testFetchCharactersFailureShowsError() async {
        //Arrange
        mockRepository.getCharactersResult = .failure(MockError.someError)
        viewModel = CharacterListViewModel(repository: mockRepository)
        
        //Act
        await viewModel.getCharacters()
        
        //Assert
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, MockError.someError.localizedDescription)
        XCTAssertFalse(viewModel.isBusy)
    }
    
    func testGetNextCharactersAppends() async {
        //Arrange
        let first = CharacterModel.mock(id: 1, name: "Rick")
        let second = CharacterModel.mock(id: 2, name: "Morty")
        let nextUrl = URL(string: "https://api.example.com?page=2")!
        let expectedCharacters = CharactersPagedModel.mock(characters: [second], nextUrl: nil)
        var expectedResult: [CharacterModel] = [first]
        expectedResult.append(contentsOf: [second])
        
        mockRepository.getNextCharactersResult = .success(expectedCharacters)
        viewModel = CharacterListViewModel(repository: mockRepository)
        viewModel.characters = [first]
        viewModel.queryItems = nextUrl.getQueryItems()
        
        //Act
        await viewModel.getNextCharacters()
        
        //Assert        
        XCTAssertEqual(viewModel.characters, expectedResult)
        XCTAssertFalse(viewModel.isBusy)
    }
    
    func testGetNextCharactersWithNoQueryItemsDoesNothing() async {
        // Arrange
        mockRepository.getNextCharactersResult = .success(CharactersPagedModel.mock(characters: [CharacterModel.mock(id: 3, name: "Summer")]))
        viewModel = CharacterListViewModel(repository: mockRepository)
        viewModel.queryItems = []

        // Act
        await viewModel.getNextCharacters()
        
        // Assert
        XCTAssertTrue(viewModel.characters.isEmpty)
    }
    
    func testApplyFiltersSuccess() async {
        // Arrange
        let filtered = CharacterModel.mock(id: 5, name: "Filtered")

        mockRepository.getCharactersByFiltersResult = .success(CharactersPagedModel.mock(characters: [filtered]))
        viewModel = CharacterListViewModel(repository: mockRepository)

        viewModel.searchText = "Filtered"
        
        // Act
        await viewModel.applyFilters(filter: CharacterFiltersModel(name: "Filtered", gender: .male, status: .alive, species: .human))
        
        // Assert
        XCTAssertEqual(viewModel.characters, [filtered])
        XCTAssertFalse(viewModel.isBusy)
    }
    
    func testApplyFiltersFailureShowsError() async {
        // Arrange
        mockRepository.getCharactersByFiltersResult = .failure(MockError.someError)
        viewModel = CharacterListViewModel(repository: mockRepository)

        viewModel.searchText = "Error"
        
        // Act
        await viewModel.applyFilters(filter: CharacterFiltersModel(name: "Error", gender: nil, status: nil, species: nil))
        
        // Assert
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, MockError.someError.localizedDescription)
        XCTAssertFalse(viewModel.isBusy)
    }
    
    func testResetFiltersResetsAll() {
        // Arrange
        viewModel = CharacterListViewModel()

        viewModel.searchText = "Rick"
        viewModel.selectedGender = .male
        viewModel.selectedStatus = .alive
        viewModel.selectedSpecies = .human
        
        // Act
        viewModel.resetFilters()
        
        // Assert
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertNil(viewModel.selectedGender)
        XCTAssertNil(viewModel.selectedStatus)
        XCTAssertNil(viewModel.selectedSpecies)
    }
    
    func testHasFiltersComputedProperty() {
        // Arrange
        viewModel = CharacterListViewModel()

        // Act & Assert
        XCTAssertFalse(viewModel.hasFilters)
        viewModel.selectedGender = .male
        XCTAssertTrue(viewModel.hasFilters)
        viewModel.selectedGender = nil
        viewModel.selectedStatus = .alive
        XCTAssertTrue(viewModel.hasFilters)
        viewModel.selectedStatus = nil
        viewModel.selectedSpecies = .human
        XCTAssertTrue(viewModel.hasFilters)
    }

}

// MARK: - Mocks y utilidades

enum MockError: Error {
    case someError
}

extension MockError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .someError: return "Mock error"
        }
    }
}


