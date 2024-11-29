
import Foundation

protocol FetchEvaluatedStudentsUseCaseProtocol {
    func execute(template: AnswerTemplate) async throws -> [EvaluatedStudent]
}

class FetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute(template: AnswerTemplate) async throws -> [EvaluatedStudent] {
        return try await repository.fetchAllStudentsFromTemplate(template: template)
    }
}
