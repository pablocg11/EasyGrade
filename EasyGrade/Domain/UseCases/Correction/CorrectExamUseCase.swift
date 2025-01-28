
import Foundation

protocol CorrectExamUseCaseProtocol {
    func execute(studentAnswers: String, template: ExamTemplate) async throws -> ExamCorrectionResult
}

class CorrectExamUseCase: CorrectExamUseCaseProtocol {
    private let service: ExamCorrectionServiceProtocol
    
    init(service: ExamCorrectionServiceProtocol) {
        self.service = service
    }
    
    func execute(studentAnswers: String, template: ExamTemplate) async throws -> ExamCorrectionResult {
        try await service.correctExam(studentAnswers: studentAnswers, template: template)
    }
}
