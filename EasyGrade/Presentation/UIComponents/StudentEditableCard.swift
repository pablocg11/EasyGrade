
import SwiftUI

struct StudentEditableCard: View {
    @Binding var student: EvaluatedStudent?
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Editar Estudiante")
                .font(.title2)
                .bold()
            
            TextField("Nombre", text: Binding(
                get: { student?.name ?? "" },
                set: { student?.name = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            TextField("DNI", text: Binding(
                get: { student?.dni ?? "" },
                set: { student?.dni = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            Button(action: onConfirm) {
                Text("Confirmar")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Button("Cancelar") {
                student = nil 
            }
            .foregroundColor(.red)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
    }
}
