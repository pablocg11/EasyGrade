
import Foundation

class ListExamTemplateViewModel: ObservableObject {
    private let getExamTemplatesUseCase: GetExamTemplatesUseCaseProtocol
    
    @Published var ExamTemplateList: [ExamTemplate] = []
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(getExamTemplatesUseCase: GetExamTemplatesUseCaseProtocol) {
        self.getExamTemplatesUseCase = getExamTemplatesUseCase
    }
    
    func onAppear() {
        showLoading = true
        errorMessage = nil
        
        Task {
            do {
                let templates = try await getExamTemplatesUseCase.execute()
                await handleResult(templates)
            } catch {
                await handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleResult(_ ExamTemplateList: [ExamTemplate]) {
        self.showLoading = false
        self.ExamTemplateList = ExamTemplateList
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        showLoading = false
        errorMessage = error.localizedDescription
    }
}
