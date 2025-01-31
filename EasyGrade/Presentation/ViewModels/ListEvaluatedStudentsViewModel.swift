
import Foundation

class ListEvaluatedStudentsViewModel: ObservableObject {
    private let fetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCaseProtocol
    private let updateEvaluatedStudentUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol
    private let deleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCaseProtocol
    private let exportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCaseProtocol
    
    @Published var errorMessage: String?
    @Published var evaluatedStudents: [EvaluatedStudent] = []
    @Published var isLoading: Bool = false
    
    init(fetchEvaluatedStudentsUseCase: FetchEvaluatedStudentsUseCaseProtocol,
         updateEvaluatedStudentUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol,
         deleteEvaluatedStudentUseCase: DeleteEvaluatedStudentUseCaseProtocol,
         exportEvaluatedStudentsFileUseCase: ExportEvaluatedStudentsFileUseCaseProtocol) {
        self.fetchEvaluatedStudentsUseCase = fetchEvaluatedStudentsUseCase
        self.updateEvaluatedStudentUseCase = updateEvaluatedStudentUseCase
        self.deleteEvaluatedStudentUseCase = deleteEvaluatedStudentUseCase
        self.exportEvaluatedStudentsFileUseCase = exportEvaluatedStudentsFileUseCase
    }
    
    func onAppear(template: ExamTemplate) {
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
    
    func exportEvaluatedStudents(template: ExamTemplate) {
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
    
    func deleteEvaluatedStudent(evaluatedStudent: EvaluatedStudent, template: ExamTemplate) {
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
    
    func updateEvaluatedStudent(evaluatedStudent: EvaluatedStudent, template: ExamTemplate) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                try await updateEvaluatedStudentUseCase.execute(student: evaluatedStudent, template: template)
                let updatedStudents = try await fetchEvaluatedStudentsUseCase.execute(template: template)
                
                await MainActor.run {
                    self.evaluatedStudents = updatedStudents
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
