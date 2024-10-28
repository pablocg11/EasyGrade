import SwiftUI

struct MainModal: View {

    var icon: String
    var message: String
    var buttonTitle: String
    var action: () -> Void
    @State private var offset: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        Group {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack( alignment: .center, spacing: 20) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(.blue))

                MainText(text: message,
                         textColor: Color(.systemGray),
                         font: .title3,
                         fontWeight: .bold,
                         textAlignment: .center)
                    .padding(.horizontal)

                Button {
                    withAnimation(.spring()) {
                        offset = UIScreen.main.bounds.height
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        action()
                    }
                } label: {
                    ZStack {
                        MainText(text: "Cerrar",
                                 textColor: Color(.blue),
                                 font: .callout,
                                 fontWeight: .bold)
                            .underline()
                    }
                }
            }
            .padding(30)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
            .padding(.horizontal, 30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
    }
}

#Preview {
    MainModal(icon: "checkmark.circle", message: "Sample text", buttonTitle: "Sample", action: {})
}
