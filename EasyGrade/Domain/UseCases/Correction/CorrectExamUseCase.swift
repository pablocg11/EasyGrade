
import Foundation

protocol CorrectExamUseCaseProtocol {
    func execute(studentAnswers: String, template: AnswerTemplate) async throws -> ExamCorrectionResult
}

class CorrectExamUseCase: CorrectExamUseCaseProtocol {
    private let repository: ExamCorrectionRepository
    
    init(repository: ExamCorrectionRepository) {
        self.repository = repository
    }
    
    func execute(studentAnswers: String, template: AnswerTemplate) async throws -> ExamCorrectionResult {
        try await repository.correctExam(studentAnswers: studentAnswers, template: template)
    }
}
