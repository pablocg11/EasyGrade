
import SwiftUI

struct EvaluatedStudentRow: View {
    @State var student: EvaluatedStudent
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 12, maxHeight: 12)
                .padding(15)
                .background(Color("AppPrimaryColor"))
                .foregroundStyle(.white)
                .cornerRadius(50)
                        
            VStack(alignment: .leading){
                MainText(text: "\(student.name) \(student.lastName)",
                         textColor: Color("AppPrimaryColor"),
                         font: .system(size: 14),
                         fontWeight: .semibold)
                MainText(text: student.dni,
                         textColor: .black,
                         font: .caption,
                         fontWeight: .light)
            }
            
            Spacer()
             
            MainText(text: String(format: "%.2f", student.score ?? 0.0),
                     textColor: student.score ?? 0.0 >= 5 ? .green : .red,
                     font: .callout,
                     fontWeight: .bold)
        }
    }
}

