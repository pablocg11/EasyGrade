
import Foundation

class ExamCorrectionViewModel: ObservableObject {
    private let examCorrectionUseCase: CorrectExamUseCase
    private let saveEvaluatedStudentUseCase: SaveEvaluatedStudentUseCase
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var examScore: ExamCorrectionResult?
    
    init(examCorrectionUseCase: CorrectExamUseCase, saveEvaluatedStudentUseCase: SaveEvaluatedStudentUseCase) {
        self.examCorrectionUseCase = examCorrectionUseCase
        self.saveEvaluatedStudentUseCase = saveEvaluatedStudentUseCase
    }
    
    func onAppear(studentAnswers: String, template: AnswerTemplate) {
        isLoading = true
        errorMessage = nil
        examScore = nil
        
        Task {
            do {
                let examCorrectionResult = try await examCorrectionUseCase.execute(studentAnswers: studentAnswers, template: template)
                await MainActor.run {
                    if !examCorrectionResult.areAnswersValid {
                        self.errorMessage = "El número de respuestas no coincide con el número de preguntas."
                        self.isLoading = false
                    } else {
                        self.handleResult(examCorrectionResult: examCorrectionResult)
                    }
                }
            } catch {
                await handleError(error)
            }
        }
    }
    
    func saveEvaluatedStudent(evaluatedStudent: EvaluatedStudent, template: AnswerTemplate) {
        isLoading = true
        
        Task {
            do {
                try await self.saveEvaluatedStudentUseCase.execute(student: evaluatedStudent,
                                                                   template: template)
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = nil
                }
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
