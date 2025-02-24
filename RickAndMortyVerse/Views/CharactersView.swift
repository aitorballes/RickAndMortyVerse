import SwiftUI

struct CharactersView: View {
    @Environment(CharactersViewModel.self) var viewModel

    var body: some View {
        NavigationStack {
            VStack {
                if let characters = viewModel.characters {
                    ScrollView (showsIndicators: false){
                        LazyVStack {
                            ForEach(characters, id: \.self.id) { character in
                                RowItemView(imageUrl: character.image, imageWidth: 60, imageHeight: 60, title: character.name, subtitle: character.status.rawValue.capitalized)
                                .padding(.horizontal)
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
            .onAppear {
                viewModel.getAllCharacters()
            }
        }
    }
}

#Preview {
    CharactersView()
        .environment(CharactersViewModel())
}
