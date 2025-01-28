
import Foundation

protocol FetchEvaluatedStudentsUseCaseProtocol {
    func execute(template: ExamTemplate) async throws -> [EvaluatedStudent]
}

class FetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCaseProtocol {
    private let repository: EvaluatedStudentRepositoryProtocol
    
    init(repository: EvaluatedStudentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(template: ExamTemplate) async throws -> [EvaluatedStudent] {
        return try await repository.fetchAllStudentsFromTemplate(template: template)
    }
}
