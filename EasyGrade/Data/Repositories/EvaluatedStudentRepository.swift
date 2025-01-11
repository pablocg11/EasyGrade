
import Foundation
import CoreData
import UIKit

protocol EvaluatedStudentRepositoryProtocol {
    func saveStudentinTemplate(student: EvaluatedStudent, template: AnswerTemplate) async throws
    func updateEvaluatedStudentScore(studentScore: ExamCorrectionResult, student: EvaluatedStudent, template: AnswerTemplate) async throws
    func fetchAllStudentsFromTemplate(template: AnswerTemplate) async throws -> [EvaluatedStudent]
}

class EvaluatedStudentRepository: EvaluatedStudentRepositoryProtocol {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func saveStudentinTemplate(student: EvaluatedStudent, template: AnswerTemplate) async throws {
        return try await self.viewContext.perform {
            let fetchRequest: NSFetchRequest<AnswerTemplateEntity> = AnswerTemplateEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", template.id as CVarArg)

            guard let templateEntity = try self.viewContext.fetch(fetchRequest).first else {
                throw NSError(domain: "SaveStudentError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Template not found."])
            }

            if let existingStudent = templateEntity.evaluatedStudents.first(where: { $0.dni == student.dni }) {
                self.viewContext.delete(existingStudent)
            }

            let studentEntity = EvaluatedStudentEntity(context: self.viewContext)
            studentEntity.id = student.id
            studentEntity.dni = student.dni
            studentEntity.score = student.score
            studentEntity.name = student.name
            studentEntity.answerMatrix = student.answerMatrix

            templateEntity.addToEvaluatedStudents(studentEntity)

            try self.saveContext()
        }
    }
    
    func updateEvaluatedStudentScore(studentScore: ExamCorrectionResult, student: EvaluatedStudent, template: AnswerTemplate) async throws {
        try await self.viewContext.perform {
            let fetchRequest: NSFetchRequest<EvaluatedStudentEntity> = EvaluatedStudentEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", student.id as CVarArg)
            
            guard let studentEntity = try self.viewContext.fetch(fetchRequest).first else {
                throw NSError(domain: "UpdateStudentError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Student not found."])
            }
            
            studentEntity.scoreValue = NSDecimalNumber(value: studentScore.totalScore)

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
                return EvaluatedStudent(
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
            
            let csvHeader = "DNI,Alumno,Puntuación,Respuestas\n"
            var csvContent = csvHeader
            
            for studentEntity in templateEntity.evaluatedStudents {
                let answerMatrixString = self.convertAnswerMatrixToString(studentEntity.answerMatrix)
                
                let studentRow = """
                        "\(studentEntity.dni ?? "")","\(studentEntity.name ?? "")","\(String(format: "%.2f", studentEntity.scoreValue?.doubleValue ?? 0.0))","\(answerMatrixString)"
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
            
            do {
                try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                throw NSError(domain: "ExportError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to write CSV file."])
            }
            
            DispatchQueue.main.async {
                self.shareCSV(fileURL: fileURL)
            }
        }
    }
    
    func shareCSV(fileURL: URL) {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = scene.windows.first?.rootViewController else {
                print("No root view controller found")
                return
            }

            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = rootViewController.view
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func convertAnswerMatrixToString(_ matrix: [[Bool]]?) -> String {
        guard let matrix = matrix else { return "" }
        
        return matrix.enumerated().map { rowIndex, row in
            row.enumerated().compactMap { columnIndex, isSelected in
                isSelected ? String(UnicodeScalar(65 + columnIndex)!) : nil
            }.joined(separator: ",")
        }.joined(separator: ";")
    }
    
    private func saveContext() throws {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                viewContext.refreshAllObjects() 
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
                throw nsError
            }
        }
    }
}

