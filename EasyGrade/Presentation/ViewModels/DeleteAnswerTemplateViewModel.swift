import Foundation

class DeleteExamTemplateViewModel: ObservableObject {
    private let deleteExamTemplateUseCase: DeleteExamTemplateUseCaseProtocol
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(deleteExamTemplateUseCase: DeleteExamTemplateUseCaseProtocol) {
        self.deleteExamTemplateUseCase = deleteExamTemplateUseCase
    }
    
    func deleteExamTemplate(templateId: UUID) {
        Task { @MainActor in
            showLoading = true
            errorMessage = nil
            
            do {
                try await deleteExamTemplateUseCase.execute(id: templateId)
            } catch {
                errorMessage = "Error al eliminar la plantilla: \(error.localizedDescription)"
            }
            
            showLoading = false
        }
    }
}
