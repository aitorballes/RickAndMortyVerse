import SwiftUI

struct CharactersView: View {
    @Environment(CharactersViewModel.self) var viewModel

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.characters.isEmpty {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.characters, id: \.self.id) {
                                character in
                                RowItemView(
                                    imageUrl: character.image, imageWidth: 60,
                                    imageHeight: 60, title: character.name,
                                    subtitle: character.status.rawValue.capitalized
                                )
                                .padding(.horizontal)
                                .onAppear {
                                    if character.id == viewModel.characters.last?.id {
                                        viewModel.getNextCharacters()
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
            .overlay {
                if viewModel.isBusy {
                    ProgressView()
                }
            }
            .onAppear {
                viewModel.getCharacters()
            }
        }
    }
}

#Preview {
    CharactersView()
        .environment(CharactersViewModel())
}
