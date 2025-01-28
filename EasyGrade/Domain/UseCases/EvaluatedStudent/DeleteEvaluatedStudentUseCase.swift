
import Foundation

protocol DeleteEvaluatedStudentUseCaseProtocol {
    func execute(student: EvaluatedStudent, template: ExamTemplate) async throws
}

class DeleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCaseProtocol {
    private let repository: EvaluatedStudentRepositoryProtocol
    
    init(repository: EvaluatedStudentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(student: EvaluatedStudent, template: ExamTemplate) async throws {
        try await self.repository.deleteStudentFromTemplate(student: student, template: template)
    }
}
