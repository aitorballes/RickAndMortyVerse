import SwiftUI

struct IconCircleView: View {
    let systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
}

#Preview {
    IconCircleView(systemName: "arrow.up")
}
