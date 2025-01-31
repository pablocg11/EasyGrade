
import Foundation

protocol GetExamTemplateUseCaseProtocol {
    func execute(id: UUID) async throws -> ExamTemplate?
}

class GetExamTemplateUseCase: GetExamTemplateUseCaseProtocol {
    private let repository: ExamTemplateRepository

    init(ExamTemplateRepository: ExamTemplateRepository) {
        self.repository = ExamTemplateRepository
    }

    func execute(id: UUID) async throws -> ExamTemplate? {
        return repository.getTemplate(id: id)
    }
}
