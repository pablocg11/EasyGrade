
import Foundation

protocol GetAnswerTemplateUseCaseType {
    func execute(id: UUID) async throws -> AnswerTemplate?
}
