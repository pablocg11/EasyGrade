
import Foundation
import CoreData


extension EvaluatedStudentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EvaluatedStudentEntity> {
        return NSFetchRequest<EvaluatedStudentEntity>(entityName: "EvaluatedStudentEntity")
    }

    @NSManaged public var dni: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var answerMatrix: [[Bool]]?
    @NSManaged public var template: AnswerTemplateEntity?
}

extension EvaluatedStudentEntity : Identifiable {

}
