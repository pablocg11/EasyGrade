
import Foundation

protocol GetAnswerTemplateUseCaseType {
    func execute(id: UUID) async throws -> AnswerTemplate?
}

class GetAnswerTemplateUseCase: GetAnswerTemplateUseCaseType {
    private let repository: AnswerTemplateRepository

    init(answerTemplateRepository: AnswerTemplateRepository) {
        self.repository = answerTemplateRepository
    }

    func execute(id: UUID) async throws -> AnswerTemplate? {
        return repository.getTemplate(id: id)
    }
}
