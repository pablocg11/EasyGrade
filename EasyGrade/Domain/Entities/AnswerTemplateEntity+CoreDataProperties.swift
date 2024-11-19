
import Foundation
import CoreData


extension AnswerTemplateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnswerTemplateEntity> {
        return NSFetchRequest<AnswerTemplateEntity>(entityName: "AnswerTemplateEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var multipleCorrectAnswers: Bool
    @NSManaged public var name: String?
    @NSManaged public var numberOfAnswersPerQuestion: Int16
    @NSManaged public var numberOfQuestions: Int16
    @NSManaged public var penaltyBlankAnswer: Double
    @NSManaged public var penaltyIncorrectAnswer: Double
    @NSManaged public var scoreCorrectAnswer: Double
    @NSManaged public var cancelledQuestions: [Bool]
    @NSManaged public var correctAnswerMatrix: [[Bool]]

}

extension AnswerTemplateEntity : Identifiable {

}
