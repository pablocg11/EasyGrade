//
//  RecognizedExamaDataView.swift
//  EasyGrade
//
//  Created by Pablo Castro on 10/1/25.
//

import SwiftUI

struct ExamCorrectionView: View {
    @State var extractedData: ExamData
    let saveAction: () -> Void
    let template: AnswerTemplate
    let examCalification: ExamCorrectionResult
    @Environment(\.dismiss) var dismiss
    
    @Binding var editableStudentName: String
    @Binding var editableStudentDNI: String
    
    var body: some View {
        VStack {
                ScrollView {
                    MainText(text: "Datos del alumno",
                             textColor: Color("AppPrimaryColor"),
                             font: .headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                    MainTextField(
                        placeholder: "Nombre",
                        text: $editableStudentName,
                        autoCapitalize: true,
                        autoCorrection: true
                    )

                    MainTextField(
                        placeholder: "DNI",
                        text: $editableStudentDNI,
                        autoCapitalize: true,
                        autoCorrection: false
                    )
                    
                    MainTextField(
                        placeholder: "Respuestas",
                        text: $extractedData.answers,
                        autoCapitalize: false,
                        autoCorrection: false
                    )
                    
                    Divider()
                        .padding(.vertical)
                                        
                    VStack {
                        MainText(text: "Resultados de la correción",
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
                    dismiss()
                },
                disabled: false
            )
            .padding()
        }
        .onAppear {
            self.editableStudentName = extractedData.name
            self.editableStudentDNI = extractedData.dni
        }
        .navigationTitle(template.name)
        .transition(.opacity.animation(.easeInOut))
        .background(Color.white)
    }
}
