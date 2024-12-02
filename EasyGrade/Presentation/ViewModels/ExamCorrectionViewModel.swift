
import Foundation

class ExamCorrectionViewModel: ObservableObject {
    private let examCorrectionUseCase: CorrectExamUseCase
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var examScore: ExamCorrectionResult?
    
    init(examCorrectionUseCase: CorrectExamUseCase) {
        self.examCorrectionUseCase = examCorrectionUseCase
    }
    
    func onAppear(studentAnswers: String, template: AnswerTemplate) {
        isLoading = true
        errorMessage = nil
        examScore = nil
        
        Task {
            do {
                let examCorrectionResult = try await examCorrectionUseCase.execute(studentAnswers: studentAnswers, template: template)
                await handleResult(examCorrectionResult: examCorrectionResult)
            } catch {
                await handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleResult(examCorrectionResult: ExamCorrectionResult) {
        self.isLoading = false
        self.examScore = examCorrectionResult
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        self.isLoading = false
        self.errorMessage = "\(error.localizedDescription)"
    }
}
