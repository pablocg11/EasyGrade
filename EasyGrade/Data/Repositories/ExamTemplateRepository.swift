
import CoreData
import SwiftUI

protocol ExamTemplateRepositoryProtocol {
    func add(template: ExamTemplate)
    func getAllTemplates() -> [ExamTemplate]
    func deleteTemplate(id: UUID)
    func updateTemplate(template: ExamTemplate)
}

class ExamTemplateRepository: ExamTemplateRepositoryProtocol {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

    func add(template: ExamTemplate) {
        let entity = ExamTemplateEntity(context: viewContext)
        entity.id = template.id
        entity.name = template.name
        entity.date = template.date
        entity.numberOfQuestions = Int16(template.numberOfQuestions)
        entity.numberOfAnswersPerQuestion = Int16(template.numberOfAnswersPerQuestion)
        entity.scoreCorrectAnswer = template.scoreCorrectAnswer
        entity.penaltyIncorrectAnswer = template.penaltyIncorrectAnswer
        entity.penaltyBlankAnswer = template.penaltyBlankAnswer
        entity.cancelledQuestions = template.cancelledQuestions
        entity.correctAnswerMatrix = template.correctAnswerMatrix
        
        entity.evaluatedStudents = Set(template.evaluatedStudents.map { student in
            let studentEntity = EvaluatedStudentEntity(context: viewContext)
            studentEntity.id = student.id
            studentEntity.dni = student.dni
            studentEntity.name = student.name
            studentEntity.scoreValue = NSDecimalNumber(value: student.score ?? 0.0)
            studentEntity.answerMatrix = student.answerMatrix
            return studentEntity
        })
        
        saveContext()
    }

    func getAllTemplates() -> [ExamTemplate] {
        let request: NSFetchRequest<ExamTemplateEntity> = ExamTemplateEntity.fetchRequest()
        do {
            let entities = try viewContext.fetch(request)
            return entities.map { entity in
                return ExamTemplate(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    date: entity.date ?? Date(),
                    numberOfQuestions: Int16(entity.numberOfQuestions),
                    numberOfAnswersPerQuestion: Int16(entity.numberOfAnswersPerQuestion),
                    scoreCorrectAnswer: entity.scoreCorrectAnswer,
                    penaltyIncorrectAnswer: entity.penaltyIncorrectAnswer,
                    penaltyBlankAnswer: entity.penaltyBlankAnswer,
                    cancelledQuestions: entity.cancelledQuestions ?? [],
                    correctAnswerMatrix: entity.correctAnswerMatrix ?? [[]],
                    students: entity.students.map { studentEntity in
                        Student(id:  studentEntity.id ?? UUID(),
                                dni: studentEntity.dni ?? "",
                                name: studentEntity.name ?? ""
                        )
                    },
                    evaluatedStudents: entity.evaluatedStudents.map { studentEntity in
                        EvaluatedStudent(
                            id: studentEntity.id ?? UUID(),
                            dni: studentEntity.dni ?? "",
                            name: studentEntity.name ?? "",
                            score: studentEntity.scoreValue?.doubleValue ?? 0.0,
                            answerMatrix: studentEntity.answerMatrix ?? [[]]
                        )
                    }
                )
            }
        } catch {
            print("Failed to fetch templates: \(error)")
            return []
        }
    }
    
    func getTemplate(id: UUID) -> ExamTemplate? {
        let request: NSFetchRequest<ExamTemplateEntity> = ExamTemplateEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let entity = try viewContext.fetch(request).first {
                let students = entity.students.map { studentEntity in
                    Student(id: studentEntity.id ?? UUID(),
                            dni: studentEntity.dni ?? "",
                            name: studentEntity.name ?? ""
                    )
                }
                
                let evaluatedStudents = entity.evaluatedStudents.map { studentEntity in
                    EvaluatedStudent(
                        id: studentEntity.id ?? UUID(),
                        dni: studentEntity.dni ?? "",
                        name: studentEntity.name ?? "",
                        score: studentEntity.scoreValue?.doubleValue ?? 0.0,
                        answerMatrix: studentEntity.answerMatrix ?? [[]]
                    )
                }
                
                return ExamTemplate(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    date: entity.date ?? Date(),
                    numberOfQuestions: Int16(entity.numberOfQuestions),
                    numberOfAnswersPerQuestion: Int16(entity.numberOfAnswersPerQuestion),
                    scoreCorrectAnswer: entity.scoreCorrectAnswer,
                    penaltyIncorrectAnswer: entity.penaltyIncorrectAnswer,
                    penaltyBlankAnswer: entity.penaltyBlankAnswer,
                    cancelledQuestions: entity.cancelledQuestions ?? [],
                    correctAnswerMatrix: entity.correctAnswerMatrix ?? [[]],
                    students: students,
                    evaluatedStudents: evaluatedStudents
                )
            } else {
                print("No template found with ID: \(id)")
                return nil
            }
        } catch {
            print("Failed to get template: \(error)")
            return nil
        }
    }

    func deleteTemplate(id: UUID) {
        let request: NSFetchRequest<ExamTemplateEntity> = ExamTemplateEntity.fetchRequest()
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

    func updateTemplate(template: ExamTemplate) {
        let request: NSFetchRequest<ExamTemplateEntity> = ExamTemplateEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", template.id as CVarArg)
        
        do {
            if let entity = try viewContext.fetch(request).first {
                entity.name = template.name
                entity.date = template.date
                entity.numberOfQuestions = Int16(template.numberOfQuestions)
                entity.numberOfAnswersPerQuestion = Int16(template.numberOfAnswersPerQuestion)
                entity.scoreCorrectAnswer = template.scoreCorrectAnswer
                entity.penaltyIncorrectAnswer = template.penaltyIncorrectAnswer
                entity.penaltyBlankAnswer = template.penaltyBlankAnswer
                entity.cancelledQuestions = template.cancelledQuestions
                entity.correctAnswerMatrix = template.correctAnswerMatrix

                let studentFetchRequest: NSFetchRequest<StudentEntity> = StudentEntity.fetchRequest()
                let evaluatedStudentFetchRequest: NSFetchRequest<EvaluatedStudentEntity> = EvaluatedStudentEntity.fetchRequest()
                
                let existingStudents = try viewContext.fetch(studentFetchRequest)
                let existingEvaluatedStudents = try viewContext.fetch(evaluatedStudentFetchRequest)
                
                existingStudents.forEach { viewContext.delete($0) }
                existingEvaluatedStudents.forEach { viewContext.delete($0) }

                let newStudentEntities = template.students.map { student in
                    let newStudent = StudentEntity(context: viewContext)
                    newStudent.id = student.id
                    newStudent.dni = student.dni
                    newStudent.name = student.name
                    return newStudent
                }
                entity.students = Set(newStudentEntities)

                let newEvaluatedStudentEntities = template.evaluatedStudents.map { student in
                    let newEvaluatedStudent = EvaluatedStudentEntity(context: viewContext)
                    newEvaluatedStudent.id = student.id
                    newEvaluatedStudent.dni = student.dni
                    newEvaluatedStudent.name = student.name
                    newEvaluatedStudent.scoreValue = NSDecimalNumber(value: student.score ?? 0.0)
                    newEvaluatedStudent.answerMatrix = student.answerMatrix
                    return newEvaluatedStudent
                }
                entity.evaluatedStudents = Set(newEvaluatedStudentEntities)

                saveContext()
            }
        } catch {
            print("Failed to update template: \(error)")
        }
    }

    private func saveContext() {
        viewContext.performAndWait {
            if viewContext.hasChanges {
                do {
                    try viewContext.save()
                } catch let error as NSError {
                    print("Error al guardar el contexto: \(error), \(error.userInfo)")
                }
            }
        }
    }
}
