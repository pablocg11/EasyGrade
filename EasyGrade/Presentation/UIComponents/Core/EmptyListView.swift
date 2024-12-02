
import SwiftUI

struct EmptyListView: View {
    var description: String
    var icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 80)
                .foregroundStyle(Color("AppPrimaryColor"))
                .padding(.vertical)
            
            MainText(text: description,
                     textColor: Color("AppPrimaryColor"),
                     font: .headline,
                     textAlignment: .center)
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .center)
    }
}
