
import SwiftUI

struct NavigationButton: View {
    var navigationTitle: String
    
    var body: some View {
        HStack {
            Text(navigationTitle)
                .foregroundColor(Color("AppPrimaryColor"))
            
            Spacer()
            
            Image(systemName: "chevron.forward")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color("AppPrimaryColor"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("AppSecondaryColor"), lineWidth: 1)
                .background(Color("AppSecondaryColor"))
                .cornerRadius(5)
        )
    }
}

#Preview {
    NavigationButton(navigationTitle: "Respuestas")
}
