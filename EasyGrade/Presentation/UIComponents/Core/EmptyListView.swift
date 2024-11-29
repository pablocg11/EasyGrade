
import SwiftUI

struct EmptyListView: View {
    @State var description: String
    
    var body: some View {
        ContentUnavailableView {
            
            VStack(spacing: 10) {
                Image(systemName: "list.bullet.clipboard.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color("AppPrimaryColor"))
                    .frame(maxWidth: 100, maxHeight: 100)
                
                MainText(text: description,
                         textColor: Color("AppPrimaryColor"),
                         font: .title3)
            }
        }
    }
}
