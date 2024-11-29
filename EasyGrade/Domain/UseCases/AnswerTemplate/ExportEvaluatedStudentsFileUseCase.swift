
import Foundation

protocol ExportEvaluatedStudentsFileUseCaseProtocol {
    func execute(template: AnswerTemplate) async throws
}

class ExportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCaseProtocol {
    private let repository: EvaluatedStudentRepository
    
    init(repository: EvaluatedStudentRepository) {
        self.repository = repository
    }
    
    func execute(template: AnswerTemplate) async throws {
        try await repository.exportEvaluatedStudentsFile(template: template)
    }
}
