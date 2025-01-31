//
//  EditEvaluatedStudent.swift
//  EasyGrade
//
//  Created by Pablo Castro on 31/1/25.
//

import SwiftUI

struct EditEvaluatedStudentView: View {
    @ObservedObject var viewModel: ListEvaluatedStudentsViewModel
    @State var student: EvaluatedStudent
    var template: ExamTemplate
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 15) {
            MainText(
                text: "Editar estudiante",
                textColor: Color("AppPrimaryColor"),
                font: .headline
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
            
            MainTextField(
                placeholder: "Nombre",
                text: $student.name,
                autoCapitalize: true,
                autoCorrection: true
            )
            
            MainTextField(
                placeholder: "DNI",
                text: $student.dni,
                autoCapitalize: false,
                autoCorrection: false
            )
            
            MainNumberTextField(
                placeholder: "Nota",
                number: Binding(
                    get: { student.score ?? 0.0 },
                    set: { student.score = $0 }
                )
            )
            
            Spacer()
            
            MainButton(
                title: "Guardar cambios",
                action: saveChanges
            )
        }
        .padding()
        .background(Color.white)
        .navigationTitle(student.name)
    }
    
    private func saveChanges() {
        let updatedStudent = EvaluatedStudent(
            id: student.id,
            dni: student.dni,
            name: student.name,
            score: student.score,
            answerMatrix: student.answerMatrix
        )
        
        viewModel.updateEvaluatedStudent(evaluatedStudent: updatedStudent,
                                         template: template)
        dismiss()
    }
}
