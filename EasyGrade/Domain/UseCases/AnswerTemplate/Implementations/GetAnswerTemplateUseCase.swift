
import Foundation

class GetAnswerTemplateUseCase: GetAnswerTemplateUseCaseType {
    
    private let repository: AnswerTemplateRepository

    init(answerTemplateRepository: AnswerTemplateRepository) {
        self.repository = answerTemplateRepository
    }

    func execute(id: UUID) async throws -> AnswerTemplate? {
        return repository.getTemplate(id: id)
    }
}
