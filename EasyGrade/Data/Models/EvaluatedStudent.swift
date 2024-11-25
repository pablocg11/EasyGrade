
import Foundation

struct EvaluatedStudent: Identifiable {
    var id: UUID
    var dni: String
    var name: String
    var answerMatrix: [[Bool]]?
    let templateId: UUID?
    
    init(id: UUID = UUID(), dni: String, name: String, answerMatrix: [[Bool]]? = nil, templateId: UUID? = nil) {
        self.id = id
        self.dni = dni
        self.name = name
        self.answerMatrix = answerMatrix
        self.templateId = templateId
    }
}
