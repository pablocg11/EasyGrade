
import Foundation

protocol GetExamTemplateUseCaseType {
    func execute(id: UUID) async throws -> ExamTemplate?
}

class GetExamTemplateUseCase: GetExamTemplateUseCaseType {
    private let repository: ExamTemplateRepository

    init(ExamTemplateRepository: ExamTemplateRepository) {
        self.repository = ExamTemplateRepository
    }

    func execute(id: UUID) async throws -> ExamTemplate? {
        return repository.getTemplate(id: id)
    }
}
