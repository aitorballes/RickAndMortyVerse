//
//  RickAndMortyVerseApp.swift
//  RickAndMortyVerse
//
//  Created by APPSPACE on 24/2/25.
//

import SwiftUI

@main
struct RickAndMortyVerseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
