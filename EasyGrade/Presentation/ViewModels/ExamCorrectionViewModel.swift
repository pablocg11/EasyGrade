
import Foundation

class ExamCorrectionViewModel: ObservableObject {
    private let examCorrectionUseCase: CorrectExamUseCaseProtocol
    private let matchStudentUseCase: MatchStudentUseCaseProtocol
    private let saveEvaluatedStudentUseCase: SaveEvaluatedStudentUseCaseProtocol
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var examScore: ExamCorrectionResult?
    @Published var matchingStudent: Student?
    
    init(examCorrectionUseCase: CorrectExamUseCaseProtocol,
         mathStudentUseCase: MatchStudentUseCaseProtocol,
         saveEvaluatedStudentUseCase: SaveEvaluatedStudentUseCaseProtocol) {
        self.examCorrectionUseCase = examCorrectionUseCase
        self.matchStudentUseCase = mathStudentUseCase
        self.saveEvaluatedStudentUseCase = saveEvaluatedStudentUseCase
    }
    
    func onAppear(studentName: String,
                  studentDNI: String,
                  studentAnswers: String,
                  template: ExamTemplate,
                  students: [Student]) {
        isLoading = true
        errorMessage = nil
        examScore = nil
        matchingStudent = nil
        
        Task {
            do {
                async let examCorrectionTask = examCorrectionUseCase.execute(studentAnswers: studentAnswers, template: template)
                async let matchingStudentTask = matchStudentUseCase.execute(recognizedName: studentName,
                                                                            recognizedDNI: studentDNI,
                                                                            students: students)
                
                let (examCorrectionResult, matchedStudent) = try await (examCorrectionTask, matchingStudentTask)
                
                await MainActor.run {
                    if !examCorrectionResult.areAnswersValid {
                        self.errorMessage = "El número de respuestas no coincide con el número de preguntas."
                        self.isLoading = false
                    } else {
                        self.handleResult(examCorrectionResult: examCorrectionResult,
                                          matchingStudent: matchedStudent)
                    }
                }
            } catch {
                await handleError(error)
            }
        }
    }
    
    func saveEvaluatedStudent(evaluatedStudent: EvaluatedStudent,
                              template: ExamTemplate) {
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
    
    func updateStudentCorrection(editedAnswers: String, student: Student, template: ExamTemplate) {
        isLoading = true
        Task {
            do {
                let newCorrectionResult = try await examCorrectionUseCase.execute(studentAnswers: editedAnswers, template: template)
                
                let updatedStudent = EvaluatedStudent(
                    id: UUID(),
                    dni: student.dni,
                    name: student.name,
                    lastName: student.lastName,
                    score: newCorrectionResult.totalScore,
                    answerMatrix: parseAnswers(editedAnswers, template: template)
                )
                
                try await saveEvaluatedStudentUseCase.execute(student: updatedStudent, template: template)
                
                await MainActor.run {
                    self.examScore = newCorrectionResult
                    self.isLoading = false
                }
                
            } catch {
                await handleError(error)
            }
        }
    }
    
    private func parseAnswers(_ answers: String, template: ExamTemplate) -> [[Bool]] {
        let totalAnswersPerQuestion = Int(template.numberOfAnswersPerQuestion)
        
        return answers.map { char in
            guard let index = char.asAnswerIndex(), index < totalAnswersPerQuestion else {
                return Array(repeating: false, count: totalAnswersPerQuestion)
            }
            
            var answerRow = Array(repeating: false, count: totalAnswersPerQuestion)
            answerRow[index] = true
            return answerRow
        }
    }
    
    @MainActor
    private func handleResult(examCorrectionResult: ExamCorrectionResult,
                              matchingStudent: Student?) {
        self.isLoading = false
        self.examScore = examCorrectionResult
        self.matchingStudent = matchingStudent
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        self.isLoading = false
        self.errorMessage = "\(error.localizedDescription)"
    }
}
