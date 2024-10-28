
import Foundation

class DeleteAnswerTemplateViewModel: ObservableObject {
    
    private let deleteAnswerTemplateUseCase: DeleteAnswerTemplateUseCaseType
    
    init(deleteAnswerTemplateUseCase: DeleteAnswerTemplateUseCaseType) {
        self.deleteAnswerTemplateUseCase = deleteAnswerTemplateUseCase
    }
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    
    func deleteAnswerTemplate(templateId: UUID) {
        
        Task { @MainActor in
            showLoading = true
            
            do {
                try await deleteAnswerTemplateUseCase.execute(id: templateId)
            }
            catch {
                errorMessage = "Error al eliminar la plantilla: \(error.localizedDescription)"
                print("Error: \(error.localizedDescription)")
            }
            
            showLoading = false
        }
        
    }
    
}
