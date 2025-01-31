import SwiftUI

struct MainNumberPicker: View {
    var placeholder: String
    var minValue: Int16
    var maxValue: Int16
    @Binding var selectedValue: Int16
    
    var body: some View {
        HStack {
            MainText(text: placeholder,
                     textColor: Color("AppPrimaryColor"),
                     font: .callout)
            Stepper("", value: $selectedValue,
                    in: minValue...maxValue)
            MainText(text: "\(selectedValue)",
                     textColor: Color("AppPrimaryColor"),
                     font: .headline)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5).stroke(Color("AppSecondaryColor"), lineWidth: 1))
        .background(Color("AppSecondaryColor"))
    }
}
