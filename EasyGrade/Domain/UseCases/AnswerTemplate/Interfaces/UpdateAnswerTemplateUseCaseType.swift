
import Foundation

protocol UpdateAnswerTemplateUseCaseType {
    func execute(template: AnswerTemplate) async throws
}
