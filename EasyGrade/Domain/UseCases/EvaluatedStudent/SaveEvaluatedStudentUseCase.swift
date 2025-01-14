
import Foundation

protocol SaveEvaluatedStudentUseCaseProtocol {
    func execute(student: EvaluatedStudent, template: AnswerTemplate) async throws
}

class SaveEvaluatedStudentUseCase: SaveEvaluatedStudentUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute(student: EvaluatedStudent, template: AnswerTemplate) async throws {
        try await repository.saveStudentinTemplate(student: student, template: template)
    }
}
