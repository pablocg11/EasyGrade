
import Foundation

protocol ExportEvaluatedStudentsFileUseCaseProtocol {
    func execute(template: ExamTemplate) async throws
}

class ExportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCaseProtocol {
    private let repository: EvaluatedStudentRepositoryProtocol
    
    init(repository: EvaluatedStudentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(template: ExamTemplate) async throws {
        try await repository.exportEvaluatedStudentsFile(template: template)
    }
}
