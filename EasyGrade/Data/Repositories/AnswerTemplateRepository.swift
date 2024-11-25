
import CoreData
import SwiftUI

protocol AnswerTemplateRepositoryProtocol {
    func add(template: AnswerTemplate)
    func getAllTemplates() -> [AnswerTemplate]
    func deleteTemplate(id: UUID)
    func updateTemplate(template: AnswerTemplate)
}

class AnswerTemplateRepository: AnswerTemplateRepositoryProtocol {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

    func add(template: AnswerTemplate) {
        let entity = AnswerTemplateEntity(context: viewContext)
        entity.id = template.id
        entity.name = template.name
        entity.date = template.date
        entity.numberOfQuestions = Int16(template.numberOfQuestions)
        entity.numberOfAnswersPerQuestion = Int16(template.numberOfAnswersPerQuestion)
        entity.multipleCorrectAnswers = template.multipleCorrectAnswers
        entity.scoreCorrectAnswer = template.scoreCorrectAnswer
        entity.penaltyIncorrectAnswer = template.penaltyIncorrectAnswer
        entity.penaltyBlankAnswer = template.penaltyBlankAnswer
        entity.cancelledQuestions = template.cancelledQuestions
        entity.correctAnswerMatrix = template.correctAnswerMatrix

        saveContext()
    }

    func getAllTemplates() -> [AnswerTemplate] {
        let request: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
        do {
            let entities = try viewContext.fetch(request)
            return entities.map { entity in
                return AnswerTemplate(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    date: entity.date ?? Date(),
                    numberOfQuestions: Int16(entity.numberOfQuestions),
                    numberOfAnswersPerQuestion: Int16(entity.numberOfAnswersPerQuestion),
                    multipleCorrectAnswers: entity.multipleCorrectAnswers,
                    scoreCorrectAnswer: entity.scoreCorrectAnswer,
                    penaltyIncorrectAnswer: entity.penaltyIncorrectAnswer,
                    penaltyBlankAnswer: entity.penaltyBlankAnswer,
                    cancelledQuestions: entity.cancelledQuestions,
                    correctAnswerMatrix: entity.correctAnswerMatrix
                )
            }
        } catch {
            print("Failed to fetch templates: \(error)")
            return []
        }
    }
    
    func getTemplate(id: UUID) -> AnswerTemplate? {
        let request: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let entity = try viewContext.fetch(request).first {
                return AnswerTemplate(id: entity.id ?? UUID(),
                                      name: entity.name ?? "",
                                      date: entity.date ?? Date(),
                                      numberOfQuestions: entity.numberOfQuestions,
                                      numberOfAnswersPerQuestion: entity.numberOfAnswersPerQuestion,
                                      multipleCorrectAnswers: entity.multipleCorrectAnswers,
                                      scoreCorrectAnswer: entity.scoreCorrectAnswer,
                                      penaltyIncorrectAnswer: entity.penaltyIncorrectAnswer,
                                      penaltyBlankAnswer: entity.penaltyBlankAnswer,
                                      cancelledQuestions: entity.cancelledQuestions,
                                      correctAnswerMatrix: entity.correctAnswerMatrix)
            }
            else {
                print("No template found with ID: \(id)")
                return nil
            }
        } catch {
            print("Failed to get template: \(error)")
            return nil
        }
    }

    func deleteTemplate(id: UUID) {
        let request: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let entity = try viewContext.fetch(request).first {
                viewContext.delete(entity)
                saveContext()
            }
        } catch {
            print("Failed to delete template: \(error)")
        }
    }

    func updateTemplate(template: AnswerTemplate) {
        let request: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", template.id as CVarArg)
        do {
            if let entity = try viewContext.fetch(request).first {
                entity.name = template.name
                entity.date = template.date
                entity.numberOfQuestions = Int16(template.numberOfQuestions)
                entity.numberOfAnswersPerQuestion = Int16(template.numberOfAnswersPerQuestion)
                entity.multipleCorrectAnswers = template.multipleCorrectAnswers
                entity.scoreCorrectAnswer = template.scoreCorrectAnswer
                entity.penaltyIncorrectAnswer = template.penaltyIncorrectAnswer
                entity.penaltyBlankAnswer = template.penaltyBlankAnswer
                entity.cancelledQuestions = template.cancelledQuestions
                entity.correctAnswerMatrix = template.correctAnswerMatrix

                saveContext()
            }
        } catch {
            print("Failed to update template: \(error)")
        }
    }

    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}