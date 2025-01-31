
import Foundation

class CreateExamTemplateViewModel: ObservableObject {
    private let createExamTemplateUseCase: CreateExamTemplateUseCaseProtocol
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(createExamTemplateUseCase: CreateExamTemplateUseCaseProtocol) {
        self.createExamTemplateUseCase = createExamTemplateUseCase
    }
    
    func createExamTemplate(name: String,
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
                let template = ExamTemplate(
                    id: UUID(),
                    name: name,
                    date: date,
                    numberOfQuestions: numberOfQuestions,
                    numberOfAnswersPerQuestion: numberOfAnswersPerQuestion,
                    scoreCorrectAnswer: scoreCorrectAnswer,
                    penaltyIncorrectAnswer: penaltyIncorrectAnswer,
                    penaltyBlankAnswer: penaltyBlankAnswer,
                    cancelledQuestions: cancelledQuestions,
                    correctAnswerMatrix: correctAnswerMatrix,
                    students: [],
                    evaluatedStudents: []
                )
                try await createExamTemplateUseCase.execute(template: template)
            } catch {
                errorMessage = "\(error.localizedDescription)"
            }
            showLoading = false
        }
    }
}
