import SwiftUI

struct ContentTabView: View {
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        TabView {
            Tab("Characters", systemImage: "person") {
                CharacterListView()
            }
            Tab("Favorites", systemImage: "star") {
                FavoriteCharactersView(viewModel: FavoriteCharactersViewModel(context: context))
            }
        }
    }
}

#Preview {
    ContentTabView()
}
