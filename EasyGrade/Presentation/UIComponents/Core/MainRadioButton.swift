import SwiftUI

struct MainRadioButton: View {
    var option: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            isSelected.toggle()
        }, label: {
            HStack {
                Text(option)
                    .font(.callout)
                    .foregroundColor(Color("AppPrimaryColor"))
                    .padding(.horizontal)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color("AppPrimaryColor"), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color("AppPrimaryColor"))
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding()
        })
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("AppSecondaryColor"), lineWidth: 1)
                .background(Color("AppSecondaryColor"))
                .cornerRadius(5)
        )
    }
}

struct MainRadioButton_Previews: PreviewProvider {
    @State static var isSelected = true

    static var previews: some View {
        MainRadioButton(option: "A", isSelected: $isSelected)
    }
}
