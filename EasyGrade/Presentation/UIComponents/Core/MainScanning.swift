
import SwiftUI
import Lottie

struct MainScanning: View {
    var body: some View {
        VStack {
            LottieView(animation: .named("scanning_animation.json"))
                .playing(loopMode: .loop)
                .animationSpeed(1)
                .frame(maxWidth: 200, maxHeight: 200)
            
            MainText(text: "Escaneando...",
                     textColor: Color("AppPrimaryColor"),
                     font: .callout)
        }
    }
}
