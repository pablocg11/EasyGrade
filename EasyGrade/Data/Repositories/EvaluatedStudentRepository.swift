
import Foundation
import CoreData
import UIKit

protocol EvaluatedStudentRepositoryProtocol {
    func saveStudentinTemplate(student: EvaluatedStudent, template: AnswerTemplate) async throws
    func fetchAllStudentsFromTemplate(template: AnswerTemplate) async throws -> [EvaluatedStudent]
}

class EvaluatedStudentRepository: EvaluatedStudentRepositoryProtocol {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func saveStudentinTemplate(student: EvaluatedStudent, template: AnswerTemplate) async throws {
        try await self.viewContext.perform {
            
            let fetchRequest: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", template.id as CVarArg)
            
            guard let templateEntity = try self.viewContext.fetch(fetchRequest).first else {
                throw NSError(domain: "SaveStudentError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Template not found."])
            }
            
            let studentEntity = EvaluatedStudentEntity(context: self.viewContext)
            studentEntity.id = student.id
            studentEntity.dni = student.dni
            studentEntity.score = student.score
            studentEntity.name = student.name
            studentEntity.answerMatrix = student.answerMatrix
            
            templateEntity.evaluatedStudents.insert(studentEntity)

            try self.saveContext()
        }
    }
    
    func deleteStudentFromTemplate(student: EvaluatedStudent, template: AnswerTemplate) async throws {
        try await self.viewContext.perform {
            let fetchRequest: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", template.id as CVarArg)
            
            guard let templateEntity = try self.viewContext.fetch(fetchRequest).first else {
                throw NSError(domain: "DeleteStudentError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Template not found."])
            }
            
            guard let studentEntity = templateEntity.evaluatedStudents.first(where: { $0.id == student.id }) else {
                throw NSError(domain: "DeleteStudentError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Student not found in template."])
            }
            
            self.viewContext.delete(studentEntity)
            
            try self.saveContext()
        }
    }
    
    func fetchAllStudentsFromTemplate(template: AnswerTemplate) async throws -> [EvaluatedStudent] {
        try await self.viewContext.perform {
            
            let fetchRequest: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", template.id as CVarArg)
            
            guard let answerTemplateEntity = try self.viewContext.fetch(fetchRequest).first else {
                throw NSError(domain: "SaveStudentError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Template not found."])
            }
            
            return answerTemplateEntity.evaluatedStudents.map { studentEntity in
                EvaluatedStudent(
                    id: studentEntity.id ?? UUID(),
                    dni: studentEntity.dni ?? "",
                    name: studentEntity.name ?? "",
                    score: studentEntity.scoreValue?.doubleValue ?? 0.0,
                    answerMatrix: studentEntity.answerMatrix ?? [[]]
                )
            }
        }
    }
    
    func exportEvaluatedStudentsFile(template: AnswerTemplate) async throws {
        try await self.viewContext.perform {
            let fetchRequest: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", template.id as CVarArg)
            
            guard let templateEntity = try self.viewContext.fetch(fetchRequest).first else {
                throw NSError(domain: "ExportError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Template not found."])
            }
            
            let csvHeader = "DNI,Alumno,Puntuación\n"
            var csvContent = csvHeader
            
            for studentEntity in templateEntity.evaluatedStudents {
                let studentRow = """
                "\(studentEntity.dni ?? "")","\(studentEntity.name ?? "")","\(studentEntity.scoreValue?.doubleValue ?? 0.0)"
                """
                csvContent.append("\(studentRow)\n")
            }
            
            let rawFileName = templateEntity.name ?? "EvaluatedStudents"
                   let sanitizedFileName = rawFileName.replacingOccurrences(of: "/", with: "_")
                                       .replacingOccurrences(of: "\\", with: "_")
                                       .replacingOccurrences(of: ":", with: "_")
                                       .replacingOccurrences(of: "*", with: "_")
                                       .replacingOccurrences(of: "?", with: "_")
                                       .replacingOccurrences(of: "\"", with: "_")
                                       .replacingOccurrences(of: "<", with: "_")
                                       .replacingOccurrences(of: ">", with: "_")
                                       .replacingOccurrences(of: "|", with: "_")
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent("\(sanitizedFileName).csv")
            
            self.shareCSV(fileURL: fileURL)
        }
    }
    
    func shareCSV(fileURL: URL) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            print("No root view controller found")
            return
        }

        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = rootViewController.view
        rootViewController.present(activityVC, animated: true, completion: nil)
    }
    
    private func saveContext() throws {
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

