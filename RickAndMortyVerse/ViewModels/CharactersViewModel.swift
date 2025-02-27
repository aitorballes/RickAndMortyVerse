import Foundation
import Observation

@Observable
class CharactersViewModel {
    private let charactersService: CharactersService

    init(charactersService: CharactersService = CharactersService()) {
        self.charactersService = charactersService
    }

    var characters: [CharacterModel] = []
    var nextPage: String?
    var isBusy: Bool = false
    var filters: CharacterFiltersModel?

    @MainActor
    func getCharacters() async {
        isBusy = true
        do {
            let result = try await charactersService.getCharacters()
            self.characters = result.results ?? []
            self.nextPage = result.info?.next
            self.isBusy = false
        } catch {
            self.isBusy = false
            print("Error fetching characters: \(error)")
        }
    }

    @MainActor
    func getCharactersByPage(page: String) async {
        isBusy = true
        do {
            let result = try await charactersService.getCharactersByPage(page: page)
            self.characters.append(contentsOf: result.results ?? [])
            self.nextPage = result.info?.next
            self.isBusy = false
        } catch {
            self.isBusy = false
            print("Error fetching characters by page: \(error)")
        }
    }

    func getNextCharacters() async {
        guard let page = nextPage, let pageNumber = page.extractPageNumber() else { return }
        await getCharactersByPage(page: pageNumber)
    }

    @MainActor
    func applyFilters(searchText: String?, gender: Gender?, status: Status?, species: Species?) async {
        self.filters = .init(
            name: searchText, gender: gender, status: status, species: species)
        if let filter = filters {
            isBusy = true
            do {
                let result = try await charactersService.getCharactersByFilters(filter: filter)
                self.characters = result.results ?? []
                self.nextPage = result.info?.next
                self.isBusy = false
            } catch {
                self.isBusy = false
                print("Error applying filters: \(error)")
            }
        }
    }
}
