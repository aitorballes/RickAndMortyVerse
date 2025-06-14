import Foundation
import Observation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"

    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .english: return String(localized: "English")
        case .spanish: return String(localized: "Spanish")
        }
    }
}

@Observable
final class TranslationManager {
    var currentLanguage = AppLanguage.english
    var locale = Locale(identifier: AppLanguage.english.rawValue)

    func setLanguage(_ identifier: AppLanguage) {
        currentLanguage = identifier
        locale = Locale(identifier: identifier.rawValue)
        UserDefaults.standard.set([identifier.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
