
import Foundation

protocol GetAnswerTemplatesUseCaseType {
    func execute() async throws -> [AnswerTemplate]
}

class GetAnswerTemplatesUseCase: GetAnswerTemplatesUseCaseType {
    private let repository: AnswerTemplateRepository

    init(answerTemplateRepository: AnswerTemplateRepository) {
        self.repository = answerTemplateRepository
    }

    func execute() -> [AnswerTemplate] {
        return repository.getAllTemplates()
    }
}

