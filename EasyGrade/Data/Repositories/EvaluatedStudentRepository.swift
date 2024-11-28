
import Foundation
import CoreData

protocol EvaluatedStudentRepositoryProtocol {
    func saveStudent(_ student: EvaluatedStudent) async throws
    func fetchAllStudents() async throws -> [EvaluatedStudent]
}

class EvaluatedStudentRepository: EvaluatedStudentRepositoryProtocol {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func saveStudent(_ student: EvaluatedStudent) async throws {
        try await viewContext.perform {
            let entity = EvaluatedStudentEntity(context: self.viewContext)
            entity.id = student.id
            entity.dni = student.dni
            entity.score = student.score
            entity.name = student.name
            entity.answerMatrix = student.answerMatrix
            
            try self.saveContext()
        }
    }
    
    func fetchAllStudents() async throws -> [EvaluatedStudent] {
        let request: NSFetchRequest<EvaluatedStudentEntity> = EvaluatedStudentEntity.fetchRequest()
        let results = try viewContext.fetch(request)
        
        return results.compactMap { entity in
            guard let id = entity.id, let name = entity.name else { return nil }
            return EvaluatedStudent(
                id: id,
                dni: entity.dni!,
                name: name,
                score: entity.score,
                answerMatrix: entity.answerMatrix
            )
        }
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

