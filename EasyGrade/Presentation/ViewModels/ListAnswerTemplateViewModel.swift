
import Foundation

class ListAnswerTemplateViewModel: ObservableObject {
    
    private let getAnswerTemplatesUseCase: GetAnswerTemplatesUseCaseType
    @Published var answerTemplateList: [AnswerTemplate] = []
    
    init(getAnswerTemplatesUseCase: GetAnswerTemplatesUseCaseType) {
        self.getAnswerTemplatesUseCase = getAnswerTemplatesUseCase
    }
    
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    func getAllAnswerTemplate() {
        
        Task { @MainActor in
            showLoading = true
            
            do {
                answerTemplateList = try await getAnswerTemplatesUseCase.execute()
            }
            catch {
                errorMessage = "Error al recuperar las plantillas: \(error.localizedDescription)"
                print("Error: \(error.localizedDescription)")
            }
            
            showLoading = false
        }
    }
}
