import SwiftUI

struct MainTextField: View {
    var placeholder: String
    @Binding var text: String
    var autoCapitalize: Bool
    var autoCorrection: Bool
    var isDisabled: Bool = false

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).stroke(Color("AppSecondaryColor"), lineWidth: 1))
            .background(Color("AppSecondaryColor"))
            .cornerRadius(5)
            .textInputAutocapitalization(autoCapitalize ? .sentences : .never)
            .autocorrectionDisabled(!autoCorrection)
            .foregroundColor(Color("AppPrimaryColor"))
            .accentColor(Color("AppPrimaryColor"))
            .disabled(isDisabled)
    }
}

