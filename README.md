# RickAndMortyVerse

A SwiftUI iOS application that explores the [Rick and Morty API](https://rickandmortyapi.com/), allowing users to browse, search, filter, and favorite characters from the universe. The project is built using modern Swift paradigms such as `@Observable`, `async/await`, Core Data, modular architecture, and XCTest for unit testing.

> 🧑‍💻 Created by [Aitor Ballesteros](https://github.com/aitorballes)

## 🚀 Features

- 📋 **Character List**: View a paginated list of Rick and Morty characters.
- 🔍 **Search & Filters**: Search by name and filter characters by status, gender, and species.
- 📄 **Character Detail**: View detailed information about each character.
- ⭐ **Favorites**: Mark and persist your favorite characters using Core Data.
- 🌍 **Localization**: Switch between available languages via the in-app translation menu.
- 🧠 **Swift Concurrency**: Data fetching is done using `async/await`.
- 🧩 **Modular Architecture**: Code is organized into clear modules for scalability and maintainability.
- 🧪 **Unit Testing**: All business logic is covered using `XCTest`.

## 🧱 Project Structure

The codebase is structured in a clean and modular way:

    RickAndMortyVerse/
    ├── DataBase/ # Core Data stack & entities
    ├── Extensions/ # Useful Swift extensions
    ├── Interactor/ # API interaction layer
    ├── Models/ # DTOs and domain models
    ├── Repositories/ # Data access layer
    ├── Resources/ # Images and assets
    ├── ViewModels/ # State & business logic
    ├── Views/ # Main UI views
    ├── Tests/
    │ ├── Unit Tests (RickAndMortyVerseTests)
    │ └── UI Tests (RickAndMortyVerseUITests)

## 📦 External Dependencies

This project uses [Swift Package Manager (SPM)](https://swift.org/package-manager/) to manage external dependencies:

- [`cachedImage`](https://github.com/aitorballes/cachedImage): A lightweight image caching module created specifically for this app and reusable in other projects.

To add it manually:
```swift
.package(url: "https://github.com/aitorballes/cachedImage", from: "1.0.0")
```

## 🧪 Testing

Unit tests are written using **XCTest** and cover:

- View models  
- Interactors  
- Repositories  
- Data logic (mocked)

The test structure mirrors the main app for clarity and maintainability.

---

## 🌍 Localization

**RickAndMortyVerse** supports multiple languages. You can change the app's language dynamically using the **Translation Menu** built into the UI.

---

## 📲 Installation

1. Clone the repository:

```bash
git clone https://github.com/aitorballes/RickAndMortyVerse.git
```

2. Open the project in Xcode:

```bash
open RickAndMortyVerse.xcodeproj
```

2. Open the project in Xcode:

```bash
File > Packages > Resolve Package Versions
```


