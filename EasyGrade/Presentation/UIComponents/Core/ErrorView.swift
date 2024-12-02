
import SwiftUI

struct ErrorView: View {
    @State var errorMessage: String
    @State var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80)
                    .foregroundStyle(Color("AppPrimaryColor"))
                    .padding(.vertical)
                
                MainText(text: "Ocurrió un error",
                         textColor: Color("AppPrimaryColor"),
                         font: .title2,
                         fontWeight: .bold)
                
                MainText(text: errorMessage,
                         textColor: Color("AppPrimaryColor"),
                         font: .headline,
                         textAlignment: .center)
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .center)
        })
    }
}
