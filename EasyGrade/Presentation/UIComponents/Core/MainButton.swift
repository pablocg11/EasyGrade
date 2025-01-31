
import SwiftUI

struct MainButton: View {
    var title: String
    var action: () -> Void
    var disabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .textCase(.uppercase)
                .padding()
                .foregroundColor(disabled ? Color("AppSecondaryColor").opacity(0.5) : Color("AppSecondaryColor"))
                .frame(maxWidth: .infinity)
                .background(disabled ? Color("AppPrimaryColor").opacity(0.5) : Color("AppPrimaryColor"))
                .cornerRadius(10)
        }
        .disabled(disabled)
    }
}
