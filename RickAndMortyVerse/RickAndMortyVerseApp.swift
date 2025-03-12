import SwiftUI

@main
struct RickAndMortyVerseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CharactersView()
                .environment(CharactersViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
