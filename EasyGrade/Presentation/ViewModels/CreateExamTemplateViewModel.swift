
import Foundation

class CreateExamTemplateViewModel: ObservableObject {
    private let createExamTemplateUseCase: CreateExamTemplateUseCaseProtocol
    private let importStudentListFromCSV: ImportStudentListFromCSVProtocol
    
    @Published var studentsImported: [Student]?
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(createExamTemplateUseCase: CreateExamTemplateUseCaseProtocol,
         importStudentListFromCSV: ImportStudentListFromCSVProtocol) {
        self.createExamTemplateUseCase = createExamTemplateUseCase
        self.importStudentListFromCSV = importStudentListFromCSV
    }
    
    func createExamTemplate(name: String,
                              date: Date,
                              numberOfQuestions: Int16,
                              numberOfAnswersPerQuestion: Int16,
                              multipleCorrectAnswers: Bool,
                              scoreCorrectAnswer: Double,
                              penaltyIncorrectAnswer: Double,
                              penaltyBlankAnswer: Double,
                              cancelledQuestions: [Bool],
                              correctAnswerMatrix: [[Bool]]) {
        
        Task { @MainActor in
            showLoading = true
            errorMessage = nil
                        
            do {
                let template = ExamTemplate(
                    id: UUID(),
                    name: name,
                    date: date,
                    numberOfQuestions: numberOfQuestions,
                    numberOfAnswersPerQuestion: numberOfAnswersPerQuestion,
                    scoreCorrectAnswer: scoreCorrectAnswer,
                    penaltyIncorrectAnswer: penaltyIncorrectAnswer,
                    penaltyBlankAnswer: penaltyBlankAnswer,
                    cancelledQuestions: cancelledQuestions,
                    correctAnswerMatrix: correctAnswerMatrix,
                    students: self.studentsImported ?? [],
                    evaluatedStudents: []
                )
                try await createExamTemplateUseCase.execute(template: template)
            } catch {
                errorMessage = "\(error.localizedDescription)"
            }
            showLoading = false
        }
    }
    
    func importStudents(from url: URL) async {
        Task { @MainActor in
            showLoading = true
            defer { showLoading = false }
        
            let result = await importStudentListFromCSV.execute(url)
            switch result {
            case .success(let students):
                self.studentsImported = students
            case .failure(let error):
                errorMessage = "Error al importar estudiantes: \(error.localizedDescription)"
            }
        }
    }
}
