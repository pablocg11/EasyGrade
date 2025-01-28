import Foundation

protocol UpdateEvaluatedStudentScoreUseCaseProtocol {
    func execute(studentScore: ExamCorrectionResult, student: EvaluatedStudent, template: ExamTemplate) async throws
}

class UpdateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol {
    private let repository: EvaluatedStudentRepositoryProtocol
    
    init(repository: EvaluatedStudentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(studentScore: ExamCorrectionResult, student: EvaluatedStudent, template: ExamTemplate) async throws {
        try await repository.updateEvaluatedStudentScore(studentScore: studentScore, student: student, template: template)
    }
}
