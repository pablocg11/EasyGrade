
import Foundation
import CoreData


extension AnswerTemplateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnswerTemplateEntity> {
        return NSFetchRequest<AnswerTemplateEntity>(entityName: "AnswerTemplateEntity")
    }

    @NSManaged public var cancelledQuestions: [Bool]?
    @NSManaged public var correctAnswerMatrix: [[Bool]]?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var multipleCorrectAnswers: Bool
    @NSManaged public var name: String?
    @NSManaged public var numberOfAnswersPerQuestion: Int16
    @NSManaged public var numberOfQuestions: Int16
    @NSManaged public var penaltyBlankAnswer: Double
    @NSManaged public var penaltyIncorrectAnswer: Double
    @NSManaged public var scoreCorrectAnswer: Double
    @NSManaged public var evaluatedStudents: Set<EvaluatedStudentEntity>

}

// MARK: Generated accessors for evaluatedStudents
extension AnswerTemplateEntity {

    @objc(addEvaluatedStudentsObject:)
    @NSManaged public func addToEvaluatedStudents(_ value: EvaluatedStudentEntity)

    @objc(removeEvaluatedStudentsObject:)
    @NSManaged public func removeFromEvaluatedStudents(_ value: EvaluatedStudentEntity)

    @objc(addEvaluatedStudents:)
    @NSManaged public func addToEvaluatedStudents(_ values: NSSet)

    @objc(removeEvaluatedStudents:)
    @NSManaged public func removeFromEvaluatedStudents(_ values: NSSet)

}

extension AnswerTemplateEntity : Identifiable {

}
