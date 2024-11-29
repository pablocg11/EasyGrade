import Foundation

class ListEvaluatedStudentsViewModel: ObservableObject {
    private let fetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCase
    private let deleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCase
    private let exportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCase
    @Published var errorMessage: String?
    @Published var evaluatedStudents: [EvaluatedStudent]
    @Published var isLoading: Bool = false
    
    init(fetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCase,
         deleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCase,
         exportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCase) {
        self.fetchEvaluatedStudentsUseCase = fetchEvaluatedStudentsUseCase
        self.deleteEvaluatedStudentUseCase = deleteEvaluatedStudentUseCase
        self.exportEvaluatedStudentsFileUseCase = exportEvaluatedStudentsFileUseCase
        self.evaluatedStudents = []
    }
    
    func onAppear(template: AnswerTemplate) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let evaluatedStudents = try await fetchEvaluatedStudentsUseCase.execute(template: template)
                await MainActor.run {
                    self.evaluatedStudents = evaluatedStudents
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
                    //handleError
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
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    //handleError
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        errorMessage = "Error al cargar la plantilla: \(error.localizedDescription)"
    }
}
