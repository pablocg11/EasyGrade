
import Foundation

protocol DeleteEvaluatedStudentUseCaseProtocol {
    func execute(student: EvaluatedStudent, template: AnswerTemplate) async throws
}

class DeleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute(student: EvaluatedStudent, template: AnswerTemplate) async throws {
        try await self.repository.deleteStudentFromTemplate(student: student, template: template)
    }
}
