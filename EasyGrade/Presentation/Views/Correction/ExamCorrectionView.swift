
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
                
                MainText(text: "Puntuación del alumno",
                         textColor: Color("AppPrimaryColor"),
                         font: .headline)
                
                HStack {
                    CorrectionProgressView(progress: examCorrectionResult.totalScore, limit: 10.0)                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("\(examCorrectionResult.correctAnswers.count)")
                                .font(.headline)
                        }
                            
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("\(examCorrectionResult.incorrectAnswers.count)")
                                .font(.headline)
                        }

                        HStack {
                            Image(systemName: "square.dashed")
                                .foregroundColor(.gray)
                            Text("\(examCorrectionResult.blankAnswers.count)")
                                .font(.headline)
                        }
                        
                        HStack {
                            Image(systemName: "nosign")
                                .foregroundColor(.red)
                            Text("\(examCorrectionResult.cancelledQuestions.count)")
                                .font(.headline)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("AppSecondaryColor"))
                .cornerRadius(10)

            } else if viewmodel.isLoading {
                MainLoading()
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
}
