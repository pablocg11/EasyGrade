
import Foundation

protocol AnswerTemplateRepositoryType {
    func add(template: AnswerTemplate)
    func getAllTemplates() -> [AnswerTemplate]
    func deleteTemplate(id: UUID)
    func updateTemplate(template: AnswerTemplate)
}
