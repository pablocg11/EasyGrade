
import Foundation

struct EvaluatedStudent: Identifiable, Hashable {
    var id: UUID
    var dni: String
    var name: String
    var lastName: String
    var score: Double?
    var answerMatrix: [[Bool]]?
    
    init(id: UUID = UUID(), dni: String, name: String, lastName: String, score: Double? = nil, answerMatrix: [[Bool]]? = nil) {
        self.id = id
        self.dni = dni
        self.name = name
        self.lastName = lastName
        self.score = score
        self.answerMatrix = answerMatrix
    }
}
