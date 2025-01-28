
import Foundation

enum ExamDataProcessingError: LocalizedError {
    case missingField(String)
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .missingField(let errorFields):
            return "Missing field: \(errorFields)"
        case .invalidFormat:
            return "El formato del examen no es el esperado"
        }
    }
}
