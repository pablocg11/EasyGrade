import Foundation

class ListEvaluatedStudentsViewModel: ObservableObject {
    private let getAnswerTemplateUseCase: GetAnswerTemplateUseCase
    @Published var errorMessage: String?
    @Published var answerTemplate: AnswerTemplate?
    @Published var isLoading: Bool = false
    
    init(getAnswerTemplateUseCase: GetAnswerTemplateUseCase) {
        self.getAnswerTemplateUseCase = getAnswerTemplateUseCase
    }
    
    func onAppear(_ templateId: UUID) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let template = try await getAnswerTemplateUseCase.execute(id: templateId)
                await MainActor.run {
                    self.answerTemplate = template
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = "Error al cargar la plantilla: \(error.localizedDescription)"
    }
}
