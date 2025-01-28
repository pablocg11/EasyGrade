
import Foundation

protocol UpdateExamTemplateUseCaseProtocol {
    func execute(template: ExamTemplate) async throws
}

class UpdateExamTemplateUseCase: UpdateExamTemplateUseCaseProtocol {
    private let repository: ExamTemplateRepositoryProtocol

    init(ExamTemplateRepository: ExamTemplateRepositoryProtocol) {
        self.repository = ExamTemplateRepository
    }

    func execute(template: ExamTemplate) async throws {
        repository.updateTemplate(template: template)
    }
}

