
import Foundation

protocol ExamCorrectionRepositoryProtocol {
    func correctExam(studentAnswers: String, template: AnswerTemplate) async throws -> Double
}

class ExamCorrectionRepository: ExamCorrectionRepositoryProtocol {
    
    func correctExam(studentAnswers: String, template: AnswerTemplate) async throws -> Double {
        print("Inicio de la corrección del examen")
        print("Respuestas del estudiante: \(studentAnswers)")
        print("Plantilla: \(template)")
        
        var totalScore = 0.0

        for (index, studentAnswer) in studentAnswers.enumerated() {
            print("\nPregunta \(index + 1):")
            print("Respuesta del estudiante: \(studentAnswer)")
            
            if index < template.cancelledQuestions.count, template.cancelledQuestions[index] {
                print("Pregunta cancelada, saltando.")
                continue
            }

            guard index < template.correctAnswerMatrix.count else {
                print("Índice fuera de rango en la matriz de respuestas correctas, saltando.")
                continue
            }
            let correctAnswers = template.correctAnswerMatrix[index]
            print("Respuestas correctas esperadas: \(correctAnswers)")
            
            guard let correctAnswerIndex = correctAnswers.firstIndex(of: true) else {
                print("No hay respuestas correctas marcadas, saltando.")
                continue
            }
            print("Índice de la respuesta correcta: \(correctAnswerIndex)")

            if studentAnswer == "-" {
                print("Respuesta no contestada, aplicando penalización: -\(template.penaltyBlankAnswer)")
                totalScore -= template.penaltyBlankAnswer
            } else if let studentAnswerIndex = studentAnswer.asAnswerIndex() {
                print("Índice de la respuesta del estudiante: \(studentAnswerIndex)")
                if studentAnswerIndex == correctAnswerIndex {
                    print("Respuesta correcta, sumando puntos: +\(template.scoreCorrectAnswer)")
                    totalScore += template.scoreCorrectAnswer
                } else {
                    print("Respuesta incorrecta, aplicando penalización: -\(template.penaltyIncorrectAnswer)")
                    totalScore -= template.penaltyIncorrectAnswer
                }
            } else {
                print("Respuesta inválida, aplicando penalización: -\(template.penaltyIncorrectAnswer)")
                totalScore -= template.penaltyIncorrectAnswer
            }
        }

        return totalScore * 10.0
    }
}

private extension Character {
    func asAnswerIndex() -> Int? {
        guard let asciiValue = self.asciiValue, asciiValue >= 65, asciiValue <= 90 else {
            print("Carácter no válido para índice: \(self)")
            return nil
        }
        let index = Int(asciiValue - 65)
        print("Carácter \(self) convertido a índice: \(index)")
        return index
    }
}
