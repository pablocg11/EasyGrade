
import Foundation

protocol DeleteExamTemplateUseCaseProtocol {
    func execute(id: UUID) async throws
}

class DeleteExamTemplateUseCase: DeleteExamTemplateUseCaseProtocol {
    private let repository: ExamTemplateRepositoryProtocol

    init(ExamTemplateRepository: ExamTemplateRepositoryProtocol) {
        self.repository = ExamTemplateRepository
    }

    func execute(id: UUID) async throws {
        repository.deleteTemplate(id: id)
    }
}
