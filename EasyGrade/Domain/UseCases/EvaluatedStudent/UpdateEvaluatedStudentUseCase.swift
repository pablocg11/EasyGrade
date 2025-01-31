import Foundation

protocol UpdateEvaluatedStudentScoreUseCaseProtocol {
    func execute(student: EvaluatedStudent, template: ExamTemplate) async throws
}

class UpdateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol {
    private let repository: EvaluatedStudentRepositoryProtocol
    
    init(repository: EvaluatedStudentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(student: EvaluatedStudent, template: ExamTemplate) async throws {
        try await repository.updateEvaluatedStudent(student: student, template: template)
    }
}
