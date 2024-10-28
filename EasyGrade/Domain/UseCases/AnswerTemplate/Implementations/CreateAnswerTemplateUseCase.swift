
import Foundation

class CreateAnswerTemplateUseCase: CreateAnswerTemplateUseCaseType {
    private let repository: AnswerTemplateRepository

    init(answerTemplateRepository: AnswerTemplateRepository) {
        self.repository = answerTemplateRepository
    }

    func execute(template: AnswerTemplate) {
        repository.add(template: template)
    }
}
