import SwiftUI

@main
struct RickAndMortyVerseApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isSplashScreenShown: Bool = true

    var body: some Scene {
        WindowGroup {
            if isSplashScreenShown {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSplashScreenShown = false
                        }
                    }

            } else {
                CharactersView()
                    .environment(CharactersViewModel())
                    .environment(
                        \.managedObjectContext,
                        persistenceController.container.viewContext)
            }
        }
    }
}
