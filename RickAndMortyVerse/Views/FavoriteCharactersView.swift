import CachedImageModule
import CoreData
import SwiftUI

struct FavoriteCharactersView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: FavoriteCharactersViewModel

    var body: some View {
        VStack {
            if !viewModel.favoriteCharacters.isEmpty {
                List {
                    ForEach(viewModel.favoriteCharacters, id: \.self) {
                        character in
                        HStack {
                            CachedImageView(
                                imageUrl: character.image,
                                size: 60
                            )

                            VStack(alignment: .leading) {
                                Text(character.name ?? "")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.leading)
                                Text("Status: \(character.status ?? "")")
                                    .font(.footnote)
                                    .fontWeight(.light)
                            }

                            Spacer()
                        }

                    }
                    .onDelete(perform: viewModel.deleteFavorite)
                }
            } else {
                ContentUnavailableView(
                    "No Favorite Characters Available",
                    systemImage: "star.fill",
                    description: Text(
                        "Try adding a new one by searching for a character in the Character List"
                    )
                )
            }
        }

        .navigationTitle("Favorite Characters")
        .onAppear {
            viewModel.fetchFavorites()
        }

    }
}
