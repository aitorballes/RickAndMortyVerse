import CoreData
import SwiftUI

struct CharactersView: View {
    @Environment(CharactersViewModel.self) var viewModel
    @Environment(\.managedObjectContext) private var context
    @State private var isFilterOpen: Bool = false
    @State private var searchText: String = ""
    @State private var selectedGender: Gender?
    @State private var selectedStatus: Status?
    @State private var selectedSpecies: Species?

    func applyFilters() {
        Task {
            await viewModel.applyFilters(
                searchText: searchText.isEmpty ? nil : searchText,
                gender: selectedGender, status: selectedStatus,
                species: selectedSpecies)
        }

    }

    func resetFilters() {
        selectedGender = nil
        selectedStatus = nil
        selectedSpecies = nil
        Task {
            await viewModel.applyFilters(
                searchText: searchText, gender: nil, status: nil, species: nil)
        }
    }

    var hasFilters: Bool {
        selectedGender != nil || selectedStatus != nil || selectedSpecies != nil
    }

    var body: some View {
        NavigationStack {
            VStack {
                if isFilterOpen {
                    HStack {

                        CharactersFilterView(
                            selectedGender: $selectedGender,
                            selectedStatus: $selectedStatus,
                            selectedSpecies: $selectedSpecies
                        )
                        .onChange(
                            of: selectedSpecies, { _, _ in applyFilters() }
                        )
                        .onChange(
                            of: selectedGender, { _, _ in applyFilters() }
                        )
                        .onChange(
                            of: selectedStatus, { _, _ in applyFilters() })

                        if hasFilters {
                            Button {
                                resetFilters()
                            } label: {
                                Image(
                                    systemName:
                                        "slider.horizontal.2.arrow.trianglehead.counterclockwise"
                                )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            }
                        }
                    }

                }

                if !viewModel.characters.isEmpty {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.characters, id: \.self.id) {
                                character in
                                CharacterRowView(character: character, context: context)
                                .padding(.horizontal)
                                .onAppear {
                                    if character.id == viewModel.characters.last?.id {
                                        Task {
                                            await viewModel.getNextCharacters()
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "No Characters Available", systemImage: "person.3.fill",
                        description: Text(
                            "Try adjusting your filters to find characters that match your search."
                        ))
                }
            }
            .navigationBarTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        FavoriteCharactersView(context: context)
                    } label: {
                        Image(systemName: "star.fill")
                            .imageScale(.large)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            isFilterOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.vertical.3")
                            .imageScale(.large)
                    }
                    .accessibilityIdentifier("filtersButton")
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search characters"
            )
            .onChange(
                of: searchText,
                { _, _ in
                    applyFilters()
                }
            )
            .overlay {
                if viewModel.isBusy {
                    ProgressView()
                }
            }
            .onAppear {
                Task {
                    await viewModel.getCharacters()
                }
            }
        }
    }
}

#Preview {
    CharactersView()
        .environment(CharactersViewModel())
}
