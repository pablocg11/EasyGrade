
import Foundation

protocol CorrectExamUseCaseProtocol {
    func execute(studentAnswers: String, template: AnswerTemplate) async throws -> Double
}

class CorrectExamUseCase: CorrectExamUseCaseProtocol {
    private let repository: ExamCorrectionRepository
    
    init(repository: ExamCorrectionRepository) {
        self.repository = repository
    }
    
    func execute(studentAnswers: String, template: AnswerTemplate) async throws -> Double {
        try await repository.correctExam(studentAnswers: studentAnswers, template: template)
    }
}
