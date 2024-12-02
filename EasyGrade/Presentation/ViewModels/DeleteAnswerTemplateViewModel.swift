import Foundation

class DeleteAnswerTemplateViewModel: ObservableObject {
    private let deleteAnswerTemplateUseCase: DeleteAnswerTemplateUseCaseType
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(deleteAnswerTemplateUseCase: DeleteAnswerTemplateUseCaseType) {
        self.deleteAnswerTemplateUseCase = deleteAnswerTemplateUseCase
    }
    
    func deleteAnswerTemplate(templateId: UUID) {
        Task { @MainActor in
            showLoading = true
            errorMessage = nil
            
            do {
                try await deleteAnswerTemplateUseCase.execute(id: templateId)
            } catch {
                errorMessage = "Error al eliminar la plantilla: \(error.localizedDescription)"
            }
            
            showLoading = false
        }
    }
}
