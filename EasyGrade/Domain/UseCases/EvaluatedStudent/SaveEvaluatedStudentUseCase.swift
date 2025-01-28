
import Foundation

protocol SaveEvaluatedStudentUseCaseProtocol {
    func execute(student: EvaluatedStudent, template: ExamTemplate) async throws
}

class SaveEvaluatedStudentUseCase: SaveEvaluatedStudentUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute(student: EvaluatedStudent, template: ExamTemplate) async throws {
        try await repository.saveStudentinTemplate(student: student, template: template)
    }
}
