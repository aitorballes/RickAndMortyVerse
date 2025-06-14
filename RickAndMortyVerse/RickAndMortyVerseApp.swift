import SwiftUI

@main
struct RickAndMortyVerseApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isSplashScreenShown: Bool = true
    @State private var selectedLocale = Locale(identifier: "es")
    @State private var translationManager = TranslationManager()
    @State private var characterListViewModel = CharacterListViewModel()

    var body: some Scene {
        WindowGroup {
            if isSplashScreenShown {
                SplashScreenView()
                    .task {
                        try? await Task.sleep(for: .seconds(2))
                        isSplashScreenShown = false                        
                    }

            } else {
                CharacterListView()
                    .environment(characterListViewModel)
                    .environment( \.managedObjectContext, persistenceController.container.viewContext)
                    .environment(translationManager)
                    .environment(\.locale, translationManager.locale)
            }
        }
    }
}
