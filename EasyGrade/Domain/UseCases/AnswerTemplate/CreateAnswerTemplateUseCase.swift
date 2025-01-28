
import Foundation

protocol CreateExamTemplateUseCaseProtocol {
    func execute(template: ExamTemplate) async throws
}

class CreateExamTemplateUseCase: CreateExamTemplateUseCaseProtocol {
    private let repository: ExamTemplateRepository

    init(ExamTemplateRepository: ExamTemplateRepository) {
        self.repository = ExamTemplateRepository
    }

    func execute(template: ExamTemplate) {
        repository.add(template: template)
    }
}
