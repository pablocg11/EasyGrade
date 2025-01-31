
import Foundation

protocol GetExamTemplateListUseCaseProtocol {
    func execute() async throws -> [ExamTemplate]
}

class GetExamTemplateListUseCase: GetExamTemplateListUseCaseProtocol {
    private let repository: ExamTemplateRepositoryProtocol

    init(ExamTemplateRepository: ExamTemplateRepositoryProtocol) {
        self.repository = ExamTemplateRepository
    }

    func execute() -> [ExamTemplate] {
        return repository.getAllTemplates()
    }
}

