
import Foundation

enum ExamRecognitionError: LocalizedError {
    case noResults
    case invalidAnswersCount(expected: Int, actual: Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .noResults:
            return "No se encontraron resultados en el reconocimiento."
        case .invalidAnswersCount(let expected, let actual):
            return "El número de respuestas (\(actual)) no coincide con el número de preguntas esperado (\(expected))."
        case .unknownError:
            return "Ocurrió un error desconocido durante el reconocimiento."
        }
    }
}
