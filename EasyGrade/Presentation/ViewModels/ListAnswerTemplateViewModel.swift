
import Foundation

class ListAnswerTemplateViewModel: ObservableObject {
    
    private let getAnswerTemplatesUseCase: GetAnswerTemplatesUseCaseType
    
    @Published var answerTemplateList: [AnswerTemplate] = []
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(getAnswerTemplatesUseCase: GetAnswerTemplatesUseCaseType) {
        self.getAnswerTemplatesUseCase = getAnswerTemplatesUseCase
    }
    
    func getAllAnswerTemplate() {
        Task { @MainActor in
            showLoading = true
            errorMessage = nil
            
            do {
                let templates = try await getAnswerTemplatesUseCase.execute()
                answerTemplateList = templates
            } catch {
                errorMessage = "\(error.localizedDescription)"
            }
            
            showLoading = false
        }
    }
}
