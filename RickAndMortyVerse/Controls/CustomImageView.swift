import SDWebImageSwiftUI
import SwiftUI

struct CustomImageView: View {
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat
    var body: some View {

        WebImage(url: URL(string: imageUrl)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "photo.circle.fill")
            }
           
            .onSuccess { image, data, cacheType in
                
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5)) 
            .scaledToFit()
            .frame(width: width, height: height, alignment: .center)
            .cornerRadius(12)

    }
}

#Preview {
    CustomImageView(
        imageUrl: "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
        width: 50, height: 50)

}
