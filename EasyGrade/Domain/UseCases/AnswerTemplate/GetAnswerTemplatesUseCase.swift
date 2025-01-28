
import Foundation

protocol GetExamTemplatesUseCaseProtocol {
    func execute() async throws -> [ExamTemplate]
}

class GetExamTemplatesUseCase: GetExamTemplatesUseCaseProtocol {
    private let repository: ExamTemplateRepositoryProtocol

    init(ExamTemplateRepository: ExamTemplateRepositoryProtocol) {
        self.repository = ExamTemplateRepository
    }

    func execute() -> [ExamTemplate] {
        return repository.getAllTemplates()
    }
}

