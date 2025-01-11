import Foundation

class EditAnswerTemplateViewModel: ObservableObject {
    
    private let updateAnswerTemplateUseCase: UpdateAnswerTemplateUseCaseType
    private let correctExamUseCase: CorrectExamUseCaseProtocol
    private let updateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol
    @Published var answerTemplate: AnswerTemplate?
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(updateAnswerTemplateUseCase: UpdateAnswerTemplateUseCaseType,
         correctExamUseCase: CorrectExamUseCaseProtocol,
         updateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol) {
        self.updateAnswerTemplateUseCase = updateAnswerTemplateUseCase
        self.correctExamUseCase = correctExamUseCase
        self.updateEvaluatedStudentScoreUseCase = updateEvaluatedStudentScoreUseCase
    }
    
    func updateAnswerTemplate(template: AnswerTemplate) async {
        Task { @MainActor in
            showLoading = true
            defer { showLoading = false }
            
            do {
                try await updateAnswerTemplateUseCase.execute(template: template)
            } catch {
                errorMessage = "Error al actualizar la plantilla: \(error.localizedDescription)"
            }
        }
    }
    
    private func convertAnswerMatrixToString(answerMatrix: [[Bool]]) -> String? {
        var result = ""
        for row in answerMatrix {
            if let selectedIndex = row.firstIndex(of: true) {
                let answerCharacter = Character(UnicodeScalar(65 + selectedIndex)!)
                result.append(answerCharacter)
            } else {
                result.append("-")
            }
        }
        return result
    }
}
