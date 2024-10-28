
import Foundation

protocol DeleteAnswerTemplateUseCaseType {
    func execute(id: UUID) async throws
}
