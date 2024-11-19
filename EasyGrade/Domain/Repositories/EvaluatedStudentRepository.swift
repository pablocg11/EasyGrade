
import Foundation
import CoreData

protocol EvaluatedStudentRepository {
    func saveStudent(_ student: EvaluatedStudent) async throws
    func fetchAllStudents() async throws -> [EvaluatedStudent]
}

class CoredDataEvaluatedStudentRepository: EvaluatedStudentRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveStudent(_ student: EvaluatedStudent) async throws {
        try await context.perform {
            let entity = EvaluatedStudentEntity(context: self.context)
            entity.id = student.id
            entity.dni = student.dni
            entity.name = student.name
            entity.answerMatrix = student.answerMatrix
            entity.template = nil
            
            try self.context.save()
        }
    }
    
    func fetchAllStudents() async throws -> [EvaluatedStudent] {
        let request: NSFetchRequest<EvaluatedStudentEntity> = EvaluatedStudentEntity.fetchRequest()
        let results = try context.fetch(request)
        
        return results.compactMap { entity in
            guard let id = entity.id, let name = entity.name else { return nil }
            return EvaluatedStudent(
                id: id,
                dni: entity.dni,
                name: name,
                answerMatrix: entity.answerMatrix,
                templateId: entity.template?.id
            )
        }
    }
}

