import SwiftUI

struct TranslationMenuView: View {
    @Environment(TranslationManager.self) var translationManager
    
    var body: some View {
        Menu {
            ForEach(AppLanguage.allCases) { language in
                Button {
                    translationManager.setLanguage(language)
                } label: {
                    HStack {
                        Text(language.displayName)
                        if translationManager.currentLanguage == language {
                            Image(systemName: "checkmark")
                        }
                            
                    }
                }
            }
        } label: {
            Label("Language", systemImage: "globe")
        }
    }
}

#Preview {
    TranslationMenuView()
}
