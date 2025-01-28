
import Foundation

protocol ExamCorrectionServiceProtocol {
    func correctExam(studentAnswers: String, template: ExamTemplate) async throws -> ExamCorrectionResult
}

class ExamCorrectionService: ExamCorrectionServiceProtocol {
    func correctExam(studentAnswers: String, template: ExamTemplate) async throws -> ExamCorrectionResult {
        let numberOfQuestions = template.correctAnswerMatrix.count
        let areAnswersValid = studentAnswers.count == numberOfQuestions
        
        var totalScore = 0.0
        var correctAnswers = [Int]()
        var incorrectAnswers = [Int]()
        var blankAnswers = [Int]()
        var cancelledQuestions = [Int]()
        
        for (index, studentAnswer) in studentAnswers.enumerated() {
            if index < template.cancelledQuestions.count, template.cancelledQuestions[index] {
                cancelledQuestions.append(index + 1)
                continue
            }
            
            guard index < template.correctAnswerMatrix.count else {
                continue
            }
            let correctAnswersMatrix = template.correctAnswerMatrix[index]
            
            guard let correctAnswerIndex = correctAnswersMatrix.firstIndex(of: true) else {
                continue
            }
            
            if studentAnswer == "-" {
                totalScore -= template.penaltyBlankAnswer
                blankAnswers.append(index + 1)
            } else if let studentAnswerIndex = studentAnswer.asAnswerIndex() {
                if studentAnswerIndex == correctAnswerIndex {
                    totalScore += template.scoreCorrectAnswer
                    correctAnswers.append(index + 1)
                } else {
                    totalScore -= template.penaltyIncorrectAnswer
                    incorrectAnswers.append(index + 1)
                }
            } else {
                totalScore -= template.penaltyIncorrectAnswer
                incorrectAnswers.append(index + 1)
            }
        }
        
        totalScore = max(0.0, min(10.0, totalScore)) 
        return ExamCorrectionResult(
            totalScore: totalScore,
            correctAnswers: correctAnswers,
            incorrectAnswers: incorrectAnswers,
            blankAnswers: blankAnswers,
            cancelledQuestions: cancelledQuestions,
            areAnswersValid: areAnswersValid
        )
    }
}

private extension Character {
    func asAnswerIndex() -> Int? {
        guard let asciiValue = self.asciiValue, asciiValue >= 65, asciiValue <= 90 else {
            return nil
        }
        let index = Int(asciiValue - 65)
        return index
    }
}
