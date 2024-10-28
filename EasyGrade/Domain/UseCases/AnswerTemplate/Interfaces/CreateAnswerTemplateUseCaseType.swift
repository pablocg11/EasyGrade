
import Foundation

protocol CreateAnswerTemplateUseCaseType {
    func execute(template: AnswerTemplate) async throws
}
