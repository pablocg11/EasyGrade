
import Foundation

class EditAnswerTemplateViewModel: ObservableObject {
    
    private let updateAnswerTemplateUseCase: UpdateAnswerTemplateUseCaseType
    @Published var answerTemplate : AnswerTemplate?

    init(updateAnswerTemplateUseCase: UpdateAnswerTemplateUseCaseType) {
        self.updateAnswerTemplateUseCase = updateAnswerTemplateUseCase
    }
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    func updateAnswerTemplate(template: AnswerTemplate) {
        Task { @MainActor in
            showLoading = true
            
            do {
                try await updateAnswerTemplateUseCase.execute(template: template)
            }
            catch {
                errorMessage = "Error al actualizar la plantilla: \(error.localizedDescription)"
                print("Error: \(error.localizedDescription)")
            }
            
            showLoading = false
        }
    }
}
