import CoreData
import SwiftUI

struct CharacterListView: View {
    @Environment(CharacterListViewModel.self) var viewModel
    @Environment(\.managedObjectContext) private var context
    
    @State private var navigationPath = NavigationPath()
    @State private var isFilterOpen: Bool = false
    @State private var showButton = false

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack(path: $navigationPath) {
            VStack {
                if isFilterOpen {
                    HStack {
                        CharactersFilterView(
                            selectedGender: $viewModel.selectedGender,
                            selectedStatus: $viewModel.selectedStatus,
                            selectedSpecies: $viewModel.selectedSpecies
                        )

                        if viewModel.hasFilters {
                            Button {
                                Task {
                                    viewModel.resetFilters()
                                    await viewModel.getCharacters()
                                }
                                
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
                    .padding(.horizontal)

                }
                               
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(showsIndicators: false) {
                        
                        ScrollDetector()
                        
                        LazyVStack {
                            ForEach(viewModel.characters) { character in
                                
                                NavigationLink(value: Route.character(character)) {
                                    CharacterRowView(
                                        character: character
                                    )
                                    .id(character.id)
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
                    }
                    .coordinateSpace(name: "scroll")
                    .onScrollPhaseChange { _, _, context in
                        let currentOffset = context.geometry.visibleRect.minY
                        if currentOffset < 0 {
                            withAnimation { showButton = false }
                        } else if currentOffset > 100 {
                            withAnimation { showButton = true }
                        }
                    }
                    .overlay {
                        if viewModel.characters.isEmpty {
                            ContentUnavailableView(
                                "No Characters Available",
                                systemImage: "person.3.fill",
                                description: Text(
                                    "Try adjusting your filters to find characters that match your search."
                                )
                            )
                        }

                        if viewModel.isBusy {
                            ProgressView()
                        }
                        
                        if showButton {
                            Button {
                                if let firstId = viewModel.characters.first?.id {
                                    withAnimation(.easeInOut) {
                                        scrollProxy.scrollTo(
                                            firstId,
                                            anchor: .top
                                        )
                                    }
                                }
                            } label: {
                                IconCircleView(systemName: "arrow.up.circle.fill")
                            }
                            .padding()
                            .transition(
                                .move(edge: .bottom).combined(with: .opacity)
                            )
                            .zIndex(1)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .bottomTrailing
                            )
                            
                     
                        }
                    }
                }
                
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .character(let character):
                    CharacterDetailView(viewModel: CharacterDetailViewModel(character: character, context: context))
                case .favorites:
                    FavoriteCharactersView(viewModel: FavoriteCharactersViewModel(context: context))
                }
            }

            .navigationBarTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    TranslationMenuView()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationPath.append(Route.favorites)
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
            .refreshable {
                await viewModel.getCharacters()
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search..."
            )
            .alert("Error", isPresented: $viewModel.showError) {
                //TODO: Probar esto
            } message: {
                Text(viewModel.errorMessage)
            }
            .task {
                await viewModel.getCharacters()
            }

        }
    }
}

#Preview {
    CharacterListView()
        .environment(CharacterListViewModel())
}
