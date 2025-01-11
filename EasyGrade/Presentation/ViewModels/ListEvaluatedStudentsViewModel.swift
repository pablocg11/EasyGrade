
import Foundation

class ListEvaluatedStudentsViewModel: ObservableObject {
    private let fetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCase
    private let deleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCase
    private let exportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCase
    
    @Published var errorMessage: String?
    @Published var evaluatedStudents: [EvaluatedStudent] = []
    @Published var isLoading: Bool = false
    
    init(fetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCase,
         deleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCase,
         exportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCase) {
        self.fetchEvaluatedStudentsUseCase = fetchEvaluatedStudentsUseCase
        self.deleteEvaluatedStudentUseCase = deleteEvaluatedStudentUseCase
        self.exportEvaluatedStudentsFileUseCase = exportEvaluatedStudentsFileUseCase
    }
    
    func onAppear(template: AnswerTemplate) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let evaluatedStudentsResult = try await fetchEvaluatedStudentsUseCase.execute(template: template)
                await MainActor.run {
                    self.evaluatedStudents = evaluatedStudentsResult
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
    
    func exportEvaluatedStudents(template: AnswerTemplate) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await exportEvaluatedStudentsFileUseCase.execute(template: template)
                await MainActor.run {
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
    
    func deleteEvaluatedStudent(evaluatedStudent: EvaluatedStudent, template: AnswerTemplate) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await deleteEvaluatedStudentUseCase.execute(student: evaluatedStudent, template: template)
                await MainActor.run {
                    self.evaluatedStudents.removeAll { $0.id == evaluatedStudent.id }
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
        errorMessage = "\(error.localizedDescription)"
    }
}
