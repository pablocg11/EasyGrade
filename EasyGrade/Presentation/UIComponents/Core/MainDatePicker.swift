import SwiftUI

struct MainDatePicker: View {
    @Binding var selectedDate: Date

    var body: some View {
        DatePicker(
            selection: $selectedDate,
            displayedComponents: .date 
        ) {
            if Calendar.current.isDateInToday(selectedDate) {
                MainText(text: "Fecha de la plantilla",
                         textColor: Color("AppPrimaryColor"),
                         font: .callout)
            } else {
                Text(DateFormatterUtility.shared.string(from: selectedDate))
            }
        }
        .datePickerStyle(CompactDatePickerStyle())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("AppSecondaryColor"), lineWidth: 1))
        .background(Color("AppSecondaryColor"))
        .cornerRadius(5)
        .foregroundColor(Color("AppPrimaryColor"))
        .accentColor(Color("AppPrimaryColor"))
    }
}

#Preview {
    MainDatePicker(selectedDate: .constant(Date()))
}
