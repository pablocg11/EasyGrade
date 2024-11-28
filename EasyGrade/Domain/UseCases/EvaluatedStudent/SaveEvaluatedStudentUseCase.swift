
import Foundation

protocol SaveEvaluatedStudentUseCaseProtocol {
    func execute(student: EvaluatedStudent) async throws
}

class SaveEvaluatedStudentUseCase: SaveEvaluatedStudentUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute(student: EvaluatedStudent) async throws {
        try await repository.saveStudent(student)
    }
}
