
import Foundation

class ListAnswerTemplateViewModel: ObservableObject {
    
    private let getAnswerTemplatesUseCase: GetAnswerTemplatesUseCaseType
    
    @Published var answerTemplateList: [AnswerTemplate] = []
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(getAnswerTemplatesUseCase: GetAnswerTemplatesUseCaseType) {
        self.getAnswerTemplatesUseCase = getAnswerTemplatesUseCase
    }
    
    func onAppear() {
        showLoading = true
        errorMessage = nil
        
        Task {
            do {
                let templates = try await getAnswerTemplatesUseCase.execute()
                await handleResult(templates)
            } catch {
                await handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleResult(_ answerTemplateList: [AnswerTemplate]) {
        self.showLoading = false
        self.answerTemplateList = answerTemplateList
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        showLoading = false
        errorMessage = error.localizedDescription
    }
}
