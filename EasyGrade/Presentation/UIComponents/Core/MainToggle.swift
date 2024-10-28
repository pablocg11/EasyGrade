import SwiftUI

struct MainToggle: View {
    var placeholder: String
    @Binding var isPressed: Bool
    var pressedText: String
    var nonPressedText: String

    var body: some View {
        HStack {
            MainText(text: placeholder,
                     textColor: Color("AppPrimaryColor"),
                     font: .callout)
            
            Spacer()
            
            Text(isPressed ? pressedText : nonPressedText)
                .foregroundColor(isPressed ? Color("AppPrimaryColor") : .gray)
                .font(.callout)
                .padding(.horizontal, 5)

            Toggle("", isOn: $isPressed)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color("AppPrimaryColor")))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5).stroke(Color("AppSecondaryColor"), lineWidth: 1))
        .background(Color("AppSecondaryColor"))
    }
}

struct MainToggle_Previews: PreviewProvider {
    @State static var isPressed = false
    
    static var previews: some View {
        MainToggle(placeholder: "¿Más de una respuesta correcta?",
                   isPressed: $isPressed,
                   pressedText: "Enabled",
                   nonPressedText: "Disabled")
    }
}
