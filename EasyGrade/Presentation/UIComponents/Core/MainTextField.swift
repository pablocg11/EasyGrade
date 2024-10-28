import SwiftUI

struct MainTextField: View {
    var placeholder: String
    @Binding var text: String
    var autoCapitalize: Bool
    var autoCorrection: Bool

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
    }
}

struct MainTextField_Previews: PreviewProvider {
    @State static var sampleText: String = ""

    static var previews: some View {
        MainTextField(placeholder: "Sample text", text: $sampleText, autoCapitalize: true, autoCorrection: true)
    }
}
