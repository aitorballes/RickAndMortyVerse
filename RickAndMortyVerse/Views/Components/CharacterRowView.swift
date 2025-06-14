import SwiftUI
import CoreData
import CachedImageModule

struct CharacterRowView: View {
    let character: CharacterModel
    
    var body: some View {
        VStack (spacing: 10) {
            HStack(alignment: .center) {
                CachedImageView(imageUrl: character.image, size: 100)
                
                
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text("Status: \(character.status.rawValue.capitalized)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text("Gender: \(character.gender.rawValue.capitalized)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text("Species: \(character.species.rawValue.capitalized)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                
            }
            
            Divider()
        }
    }
}

