import SwiftUI

struct MainNumberTextField: View {
    var placeholder: String
    @Binding var number: Double
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Text(placeholder)
                .foregroundColor(Color("AppPrimaryColor"))

            Spacer()

            TextField("", value: $number, formatter: NumberFormatter.decimal)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color("AppPrimaryColor"))
                .focused($isFocused)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("AppSecondaryColor"), lineWidth: 1)
        )
        .background(Color("AppSecondaryColor"))
        .cornerRadius(5)
        .onTapGesture {
            isFocused = true
        }
    }
}

struct MainNumberTextField_Previews: PreviewProvider {
    @State static var sampleNumber: Double = 0.0

    static var previews: some View {
        MainNumberTextField(placeholder: "Enter number", number: $sampleNumber)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
