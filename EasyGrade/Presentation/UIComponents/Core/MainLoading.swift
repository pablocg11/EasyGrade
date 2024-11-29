
import SwiftUI
import Lottie

struct MainLoading: View {
    var body: some View {
        LottieView(animation: .named("loading_animation.json"))
            .playing(loopMode: .loop)
            .animationSpeed(1)
            .frame(maxWidth: 200, maxHeight: 200)
    }
}

#Preview {
    MainLoading()
}
