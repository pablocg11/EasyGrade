
import Foundation

struct ExamCorrectionResult {
    let totalScore: Double
    let correctAnswers: [Int]
    let incorrectAnswers: [Int]
    let blankAnswers: [Int]
    let cancelledQuestions: [Int]
}
