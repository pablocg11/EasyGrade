
import Foundation

class UpdateAnswerTemplateUseCase: UpdateAnswerTemplateUseCaseType {
    private let repository: AnswerTemplateRepository

    init(answerTemplateRepository: AnswerTemplateRepository) {
        self.repository = answerTemplateRepository
    }

    func execute(template: AnswerTemplate) async throws {
        repository.updateTemplate(template: template)
    }
}

