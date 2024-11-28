
import SwiftUI

struct ExamCorrectionView: View {
    @ObservedObject var viewmodel: ExamCorrectionViewModel
    @State var student: EvaluatedStudent
    @State var template: AnswerTemplate
    @State var studentAnswers: String
    
    init(viewmodel: ExamCorrectionViewModel, student: EvaluatedStudent, template: AnswerTemplate, studentAnswers: String) {
        self.viewmodel = viewmodel
        self._student = State(initialValue: student)
        self._template = State(initialValue: template)
        self._studentAnswers = State(initialValue: studentAnswers)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let examCorrectionResult = viewmodel.examScore {
                sectionHeader("Puntuación del alumno")

                CorrectionProgressView(progress: examCorrectionResult.totalScore, limit: 100.0)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("\(examCorrectionResult.correctAnswers.count)")
                        .font(.headline)
                        
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("\(examCorrectionResult.incorrectAnswers.count)")
                        .font(.headline)

                    Image(systemName: "square.dashed")
                        .foregroundColor(.gray)
                    Text("\(examCorrectionResult.blankAnswers.count)")
                        .font(.headline)
                    
                    Image(systemName: "nosign")
                        .foregroundColor(.red)
                    Text("\(examCorrectionResult.cancelledQuestions.count)")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .center)

            } else if viewmodel.isLoading {
                ProgressView("Corrigiendo...")
                    .font(.headline)
                    .padding()
            } else if let errorMessage = viewmodel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding(.vertical)
        .onAppear {
            viewmodel.onAppear(studentAnswers: studentAnswers, template: template)
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(Color("AppPrimaryColor"))
            .padding(.vertical, 4)
    }
}
