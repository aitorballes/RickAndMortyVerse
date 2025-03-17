import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimated = false

    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)

            VStack(spacing: 20) {
                Image(.logo)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : -50)

                Image(.banner)
                    .resizable()
                    .scaledToFit()
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isAnimated = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
