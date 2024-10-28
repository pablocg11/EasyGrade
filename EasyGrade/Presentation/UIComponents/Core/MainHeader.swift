import SwiftUI

struct NavigationHeader: View {

    var headerTitle: String
    var action: () -> Void

    var body: some View {

        HStack {

            Button(action: {
                action()
            }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            })
            .padding(.leading, 10)

            Spacer()

            MainText(text: headerTitle, textColor: .white, font: .headline, fontWeight: .semibold)

            Spacer()

            Image(systemName: "arrow.left")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .hidden()
                .disabled(true)
                .padding(.trailing, 10)
        }
        .frame(height: 80)
        .padding(.horizontal)
        .background(Color("AppPrimaryColor"))
        .foregroundColor(.white)
    }
}

#Preview {
    NavigationHeader(headerTitle: "Sample title", action: {})
}
