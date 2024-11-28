
import Foundation

struct EvaluatedStudent: Identifiable, Hashable {
    var id: UUID
    var dni: String
    var name: String
    var score: Double?
    var answerMatrix: [[Bool]]?
    
    init(id: UUID = UUID(), dni: String, name: String, score: Double? = nil, answerMatrix: [[Bool]]? = nil) {
        self.id = id
        self.dni = dni
        self.name = name
        self.score = score
        self.answerMatrix = answerMatrix
    }
}
