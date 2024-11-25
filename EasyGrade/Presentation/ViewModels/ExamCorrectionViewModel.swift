
import Foundation

class ExamCorrectionViewModel: ObservableObject {
    private let examCorrectionUseCase: CorrectExamUseCase
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var examScore: Double?
    
    init(examCorrectionUseCase: CorrectExamUseCase) {
        self.examCorrectionUseCase = examCorrectionUseCase
    }
    
    func onAppear(studentAnswers: String, template: AnswerTemplate) {
        isLoading = true
        errorMessage = nil
        examScore = nil
        
        Task {
            do {
                let score = try await examCorrectionUseCase.execute(studentAnswers: studentAnswers, template: template)
                await handleResult(score: score)
            } catch {
                await handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleResult(score: Double) {
        self.isLoading = false
        self.examScore = score
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        self.isLoading = false
        self.errorMessage = "Ocurrió un error: \(error.localizedDescription)"
    }
}
