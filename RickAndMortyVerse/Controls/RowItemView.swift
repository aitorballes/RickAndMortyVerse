import SwiftUI

struct RowItemView: View {
    let imageUrl: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let title: String
    let subtitle: String
    
    var body: some View {
        NavigationLink {
            Text("Detail character view")
        } label: {
            HStack {
                CustomImageView(imageUrl: imageUrl, width: imageWidth, height: imageHeight)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                    Text("Status: \(subtitle)")
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

#Preview {
    RowItemView(imageUrl: "https://rickandmortyapi.com/api/character/avatar/361.jpeg", imageWidth: 50, imageHeight: 50, title: "Title", subtitle: "Subtitle")
}
