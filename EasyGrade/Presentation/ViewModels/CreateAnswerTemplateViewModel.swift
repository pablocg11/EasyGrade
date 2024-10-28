
import Foundation

class CreateAnswerTemplateViewModel: ObservableObject {
    
    private let createAnswerTemplateUseCase: CreateAnswerTemplateUseCaseType
 
    init(createAnswerTemplateUseCase: CreateAnswerTemplateUseCaseType) {
        self.createAnswerTemplateUseCase = createAnswerTemplateUseCase
    }
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    func createAnswerTemplate(name: String,
                                  date: Date,
                                  numberOfQuestions: Int16,
                                  numberOfAnswersPerQuestion: Int16,
                                  multipleCorrectAnswers: Bool,
                                  scoreCorrectAnswer: Double,
                                  penaltyIncorrectAnswer: Double,
                                  penaltyBlankAnswer: Double,
                                  cancelledQuestions: [Bool],
                                  correctAnswerMatrix: [[Bool]]) {
        
        Task { @MainActor in
            showLoading = true
            do {
                let template = AnswerTemplate(
                    id: UUID(),
                    name: name,
                    date: date,
                    numberOfQuestions: numberOfQuestions,
                    numberOfAnswersPerQuestion: numberOfAnswersPerQuestion,
                    multipleCorrectAnswers: multipleCorrectAnswers,
                    scoreCorrectAnswer: scoreCorrectAnswer,
                    penaltyIncorrectAnswer: penaltyIncorrectAnswer,
                    penaltyBlankAnswer: penaltyBlankAnswer,
                    cancelledQuestions: cancelledQuestions,
                    correctAnswerMatrix: correctAnswerMatrix
                )
                try await createAnswerTemplateUseCase.execute(template: template)
            }
            catch {
                errorMessage = "Error al crear la plantilla: \(error.localizedDescription)"
                print("Error: \(error.localizedDescription)")
            }
            
            showLoading = false
        }
    }
}
