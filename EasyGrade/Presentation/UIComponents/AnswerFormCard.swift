import SwiftUI

struct AnswerFormCard: View {
    @State var question: String
    @State var numberOfAnswers: Int
    @Binding var selectedAnswer: String?
    @Binding var correctAnswersMatrix: [[Bool]]
    var questionIndex: Int
    var moreThanOneAnswer: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .foregroundColor(Color("AppPrimaryColor"))
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(0..<numberOfAnswers, id: \.self) { index in
                let answerOption = String(UnicodeScalar(65 + index)!)
                MainRadioButton(option: answerOption,
                                                isSelected: Binding<Bool>(
                                                    get: { self.correctAnswersMatrix[questionIndex][index] },
                                                    set: { newValue in
                                                        updateCorrectAnswersMatrix(for: index, isSelected: newValue)
                                                    }
                                                )
                                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("AppSecondaryColor"), lineWidth: 1)
                .background(Color("AppSecondaryColor"))
                .cornerRadius(5)
        )
    }

    func updateCorrectAnswersMatrix(for index: Int, isSelected: Bool) {
        if moreThanOneAnswer {
            correctAnswersMatrix[questionIndex][index] = isSelected
        } else {
            if isSelected {
                for i in 0..<correctAnswersMatrix[questionIndex].count {
                    correctAnswersMatrix[questionIndex][i] = false
                }
                correctAnswersMatrix[questionIndex][index] = true
            } else {
                correctAnswersMatrix[questionIndex][index] = false
            }
        }
    }
}

struct AnswerFormCard_Previews: PreviewProvider {
    @State static var selectedAnswer: String? = nil
    @State static var correctAnswersMatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: 4), count: 1)

    static var previews: some View {
        AnswerFormCard(question: "¿Pregunta de ejemplo?",
                       numberOfAnswers: 4,
                       selectedAnswer: $selectedAnswer,
                       correctAnswersMatrix: $correctAnswersMatrix,
                       questionIndex: 0,
                       moreThanOneAnswer: true)
    }
}
