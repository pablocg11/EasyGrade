
import Foundation

protocol FetchEvaluatedStudentsUseCaseProtocol {
    func execute() async throws -> [EvaluatedStudent]
}

class FetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [EvaluatedStudent] {
        return try await repository.fetchAllStudents()
    }
}
