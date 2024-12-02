
import Foundation

class CreateAnswerTemplateViewModel: ObservableObject {
    private let createAnswerTemplateUseCase: CreateAnswerTemplateUseCaseType
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(createAnswerTemplateUseCase: CreateAnswerTemplateUseCaseType) {
        self.createAnswerTemplateUseCase = createAnswerTemplateUseCase
    }
    
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
            errorMessage = nil
            
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
                    correctAnswerMatrix: correctAnswerMatrix,
                    evaluatedStudents: []
                )
                try await createAnswerTemplateUseCase.execute(template: template)
            } catch {
                errorMessage = "\(error.localizedDescription)"
            }
            showLoading = false
        }
    }
}
