
import Foundation

enum ExamRecognitionError: LocalizedError {
    case noResults
    case noName
    case noDNI
    case noAnswers
    case invalidAnswersCount(expected: Int, actual: Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .noResults:
            return "No se encontraron resultados en el reconocimiento."
        case .noName:
            return "No se encontró un nombre en el examen."
        case .noDNI:
            return "No se encontró un DNI en el examen."
        case .noAnswers:
            return "No se encontraron respuestas en el examen."
        case .invalidAnswersCount(let expected, let actual):
            return "El número de respuestas (\(actual)) no coincide con el número de preguntas esperado (\(expected))."
        case .unknownError:
            return "Ocurrió un error desconocido durante el reconocimiento."
        }
    }
}
