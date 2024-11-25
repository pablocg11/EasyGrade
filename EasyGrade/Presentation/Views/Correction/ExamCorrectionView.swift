
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
        VStack {
            if let examScore = viewmodel.examScore {
                CorrectionProgressView(progress: examScore, limit: 100.0)
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
        .navigationTitle(student.name)
        .onAppear {
            viewmodel.onAppear(studentAnswers: studentAnswers, template: template)
        }
    }
}
