import Foundation
import Observation

@Observable
final class CharacterListViewModel {    
    private let repository: DataRepository
    
    init(repository: DataRepository = NetworkRepository()) {
        self.repository = repository
    }
    
    // MARK: - Properties
    var characters: [CharacterModel] = []
    var queryItems: [URLQueryItem] = []
    var isBusy: Bool = false
    var filters: CharacterFiltersModel?
    var searchTask: Task<Void, Error>?
    var errorMessage = ""
    var showError = false
    
    // MARK: Computed Properties
    var selectedGender: Gender? = nil {
        didSet {
            Task {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }
    
    var selectedStatus: Status? = nil {
        didSet {
            Task {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }
    
    var selectedSpecies: Species? = nil {
        didSet {
            Task {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }

    var searchText: String = "" {
        didSet {
            Task {
                await search()
            }
        }
    }
    
    var hasFilters: Bool {
        selectedGender != nil || selectedStatus != nil || selectedSpecies != nil
    }
    
    
    

    // MARK: - Methods
    func getCharacters() async {
        isBusy = true
        do {
            let result = try await repository.getCharacters()
            characters = result.characters
            queryItems = result.nextUrl?.getQueryItems() ?? []
       
        } catch {
            self.isBusy = false
            print("Error fetching characters: \(error)")
            errorMessage = error.localizedDescription
            showError = true
        }
        isBusy = false
    }

    func getNextCharacters() async {
        guard !queryItems.isEmpty else { return }
        isBusy = true
        
        do {
            let result = try await repository.getNextCharacters(nextQuery: queryItems)
            let newCharacters = result.characters
            characters.append(contentsOf: newCharacters)
            queryItems = result.nextUrl?.getQueryItems() ?? []
        } catch {
            print("Error fetching characters by page: \(error)")
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isBusy = false
    }

    func applyFilters(filter: CharacterFiltersModel) async {
        guard !searchText.isEmpty || hasFilters else { return }
        isBusy = true
        
        do {
            let result = try await repository.getCharactersByFilters(filter: filter)
            characters = result.characters
            queryItems = result.nextUrl?.getQueryItems() ?? []
        } catch {
            print("Error applying filters: \(error)")
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isBusy = false
    }
    
    func resetFilters() {
        searchText = ""
        selectedGender = nil
        selectedStatus = nil
        selectedSpecies = nil
    }

    private func search() async {
        if searchTask != nil {
            searchTask?.cancel()
            searchTask = nil
        }

        searchTask = Task {
            try await Task.sleep(for: .seconds(0.5))

            if !Task.isCancelled {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }

    private func setCurrentFilters() -> CharacterFiltersModel {
        return CharacterFiltersModel(
            name: searchText,
            gender: selectedGender,
            status: selectedStatus,
            species: selectedSpecies
        )

    }
}
