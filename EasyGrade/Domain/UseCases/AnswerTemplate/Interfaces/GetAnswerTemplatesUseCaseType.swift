
import Foundation

protocol GetAnswerTemplatesUseCaseType {
    func execute() async throws -> [AnswerTemplate]
}
