import SwiftUI
import CoreData

struct CharacterRowView: View {
    let character: CharacterModel
    let imageWidth = 60.0
    let imageHeight = 60.0
    let context: NSManagedObjectContext
    
    var body: some View {
        NavigationLink {
            CharacterDetailView(character: character, context: context)
        } label: {
            HStack {
                CustomImageView(imageUrl: character.image, width: imageWidth, height: imageHeight, cornerRadius: 12)

                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    Text("Status: \(character.status.rawValue.capitalized)")
                    .font(.footnote)
                    .fontWeight(.light)
                }
                
                Spacer()
                
                Image(systemName: "chevron.compact.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20, alignment: .center)
            
            }
        }
    }
}

