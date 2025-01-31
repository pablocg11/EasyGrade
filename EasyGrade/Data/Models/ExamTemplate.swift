
import Foundation

struct ExamTemplate: Identifiable, Hashable {
    var id: UUID
    var name: String
    var date: Date
    var numberOfQuestions: Int16
    var numberOfAnswersPerQuestion: Int16
    var scoreCorrectAnswer: Double
    var penaltyIncorrectAnswer: Double
    var penaltyBlankAnswer: Double
    var cancelledQuestions: [Bool]
    var correctAnswerMatrix: [[Bool]]
    var students: [Student]
    var evaluatedStudents: [EvaluatedStudent]
}
