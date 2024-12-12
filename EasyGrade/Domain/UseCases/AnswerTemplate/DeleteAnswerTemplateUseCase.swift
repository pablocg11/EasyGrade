
import Foundation

protocol DeleteAnswerTemplateUseCaseType {
    func execute(id: UUID) async throws
}

class DeleteAnswerTemplateUseCase: DeleteAnswerTemplateUseCaseType {
    private let repository: AnswerTemplateRepository

    init(answerTemplateRepository: AnswerTemplateRepository) {
        self.repository = answerTemplateRepository
    }

    func execute(id: UUID) async throws {
        repository.deleteTemplate(id: id)
    }
}
