import Foundation

class EditExamTemplateViewModel: ObservableObject {
    
    private let updateExamTemplateUseCase: UpdateExamTemplateUseCaseProtocol
    private let correctExamUseCase: CorrectExamUseCaseProtocol
    private let updateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol
    @Published var ExamTemplate: ExamTemplate?
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(updateExamTemplateUseCase: UpdateExamTemplateUseCaseProtocol,
         correctExamUseCase: CorrectExamUseCaseProtocol,
         updateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol) {
        self.updateExamTemplateUseCase = updateExamTemplateUseCase
        self.correctExamUseCase = correctExamUseCase
        self.updateEvaluatedStudentScoreUseCase = updateEvaluatedStudentScoreUseCase
    }
    
    func updateExamTemplate(template: ExamTemplate) async {
        Task { @MainActor in
            showLoading = true
            defer { showLoading = false }
            
            do {
                try await updateExamTemplateUseCase.execute(template: template)
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
