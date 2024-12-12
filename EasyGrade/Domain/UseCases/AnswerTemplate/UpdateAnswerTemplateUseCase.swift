
import Foundation

protocol UpdateAnswerTemplateUseCaseType {
    func execute(template: AnswerTemplate) async throws
}

class UpdateAnswerTemplateUseCase: UpdateAnswerTemplateUseCaseType {
    private let repository: AnswerTemplateRepository

    init(answerTemplateRepository: AnswerTemplateRepository) {
        self.repository = answerTemplateRepository
    }

    func execute(template: AnswerTemplate) async throws {
        repository.updateTemplate(template: template)
    }
}

