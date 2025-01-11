import Foundation

protocol UpdateEvaluatedStudentScoreUseCaseProtocol {
    func execute(studentScore: ExamCorrectionResult, student: EvaluatedStudent, template: AnswerTemplate) async throws
}

class UpdateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute(studentScore: ExamCorrectionResult, student: EvaluatedStudent, template: AnswerTemplate) async throws {
        try await repository.updateEvaluatedStudentScore(studentScore: studentScore, student: student, template: template)
    }
}
