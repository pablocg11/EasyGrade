
import Foundation

struct EvaluatedStudent: Identifiable {
    var id: UUID
    var dni: String?
    var name: String
    var answerMatrix: [[Bool]]?
    let templateId: UUID?
}
