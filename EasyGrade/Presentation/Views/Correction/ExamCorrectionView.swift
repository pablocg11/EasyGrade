//
//  RecognizedExamaDataView.swift
//  EasyGrade
//
//  Created by Pablo Castro on 10/1/25.
//

import SwiftUI

struct ExamCorrectionView: View {
    @State var extractedData: ExamData
        var matchingStudent: Student?
        let saveAction: () -> Void
        let template: ExamTemplate
        let examCalification: ExamCorrectionResult
        @Binding var selectedStudent: Student?
        @State var showNotification: Bool = false

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    MainText(text: "Datos del alumno",
                             textColor: Color("AppPrimaryColor"),
                             font: .headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                    if let student = selectedStudent ?? matchingStudent {
                        MainTextField(
                            placeholder: "Nombre",
                            text: .constant(student.name),
                            autoCapitalize: true,
                            autoCorrection: true,
                            isDisabled: true
                        )
                        
                        MainTextField(
                            placeholder: "DNI",
                            text: .constant(student.dni),
                            autoCapitalize: true,
                            autoCorrection: false,
                            isDisabled: true
                        )
                    } else if template.students.count > 0 {
                        MainSelector(placeholder: "Selecciona el alumno",
                                     students: template.students,
                                     selectedStudent: $selectedStudent)
                    } else {
                        MainText(text: "Debe importar alumnos primero para poder seleccionarlos",
                                 font: .callout)
                        .padding()
                    }
                    
                    MainTextField(
                        placeholder: "Respuestas reconocidas",
                        text: .constant(extractedData.answers), 
                        autoCapitalize: false,
                        autoCorrection: false,
                        isDisabled: true
                    )
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack {
                        MainText(text: "Resultados de la corrección",
                                 textColor: Color("AppPrimaryColor"),
                                 font: .headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            CorrectionProgressView(progress: examCalification.totalScore, limit: 10)
                            
                            VStack(spacing: 10) {
                                MainText(text: "✅ \(examCalification.correctAnswers.count)",
                                         textColor: .primary,
                                         font: .callout,
                                         fontWeight: .bold)
                                
                                MainText(text: "❌ \(examCalification.incorrectAnswers.count)",
                                         textColor: .primary,
                                         font: .callout,
                                         fontWeight: .bold)
                                
                                MainText(text:"➖ \(examCalification.blankAnswers.count)",
                                         textColor: .primary,
                                         font: .callout,
                                         fontWeight: .bold)
                            }
                        }
                    }
                    .padding()
                    .background(Color("AppSecondaryColor"))
                    .cornerRadius(10)
                }
                .scrollIndicators(.hidden)
                .padding()
                
                MainButton(
                    title: "Guardar",
                    action: {
                        saveAction()
                    },
                    disabled: selectedStudent == nil
                )
                .padding()
            }
            
            if showNotification {
                notificationView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                showNotification = false
                            }
                        }
                    }
            }
        }
        .onAppear {
            if matchingStudent != nil {
                selectedStudent = matchingStudent
            } else {
                showNotification = true
            }
        }
        .navigationTitle(template.name)
        .transition(.opacity.animation(.easeInOut))
        .background(Color.white)
    }
    
    private func notificationView() -> some View {
        ConfirmationNotification(titleNotification: "No hay coincidencia fiable",
                                 messageNotification: "No se ha podido asociar automáticamente un estudiante",
                                 error: true)
        .transition(.scale(scale: 0.9).combined(with: .opacity).animation(.easeInOut))
    }
}
