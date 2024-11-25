
import SwiftUI

struct CorrectAnswersView: View {
    
    @Binding var correctAnswerMatrix: [[Bool]]
    @Binding var numberOfQuestions: Int16
    @Binding var numberOfAnswers: Int16
    @Binding var moreThanOneAnswer: Bool
    
    func letterForIndex(_ index: Int) -> String {
        let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return String(letters[index % letters.count])
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(0..<Int(numberOfQuestions), id: \.self) { questionIndex in
                    MainText(text: "Pregunta \(questionIndex + 1)",
                             textColor: Color("AppPrimaryColor"),
                             font: .callout)
                        ForEach(0..<Int(numberOfAnswers), id: \.self) { answerIndex in
                            MainRadioButton(option: "Respuesta \(letterForIndex(answerIndex))",
                                            isSelected: Binding<Bool>(
                                                get: { correctAnswerMatrix[questionIndex][answerIndex] },
                                                set: { newValue in
                                                    if moreThanOneAnswer {
                                                        correctAnswerMatrix[questionIndex][answerIndex] = newValue
                                                    } else {
                                                        for index in 0..<Int(numberOfAnswers) {
                                                            correctAnswerMatrix[questionIndex][index] = (index == answerIndex) ? newValue : false
                                                        }
                                                    }
                                                }
                                            ))
                        
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Respuestas correctas")
    }
}

