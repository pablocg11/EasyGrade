import Foundation

class EditExamTemplateViewModel: ObservableObject {
    
    private let updateExamTemplateUseCase: UpdateExamTemplateUseCaseProtocol
    private let correctExamUseCase: CorrectExamUseCaseProtocol
    private let updateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol
    private let importStudentListFromCSV: ImportStudentListFromCSVProtocol
    private let reEvaluatedStudentListUseCase: ReevaluateStudentListUseCaseProtocol
    @Published var ExamTemplate: ExamTemplate?
    @Published var studentsImported: [Student]?
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(updateExamTemplateUseCase: UpdateExamTemplateUseCaseProtocol,
         correctExamUseCase: CorrectExamUseCaseProtocol,
         updateEvaluatedStudentScoreUseCase: UpdateEvaluatedStudentScoreUseCaseProtocol,
         importStudentListFromCSV: ImportStudentListFromCSVProtocol,
         reEvaluatedStudentListUseCase: ReevaluateStudentListUseCaseProtocol) {
        self.updateExamTemplateUseCase = updateExamTemplateUseCase
        self.correctExamUseCase = correctExamUseCase
        self.updateEvaluatedStudentScoreUseCase = updateEvaluatedStudentScoreUseCase
        self.importStudentListFromCSV = importStudentListFromCSV
        self.reEvaluatedStudentListUseCase = reEvaluatedStudentListUseCase
    }
    
    func updateExamTemplate(template: ExamTemplate) async {
        Task { @MainActor in
            showLoading = true
            defer { showLoading = false }

            do {
                try await updateExamTemplateUseCase.execute(template: template)
                
                var reevaluatedStudents: [EvaluatedStudent] = []
                if !template.evaluatedStudents.isEmpty {
                    reevaluatedStudents = try await reEvaluatedStudentListUseCase.execute(evaluatedStudentList: template.evaluatedStudents, template: template)
                }
                
                let sortedStudents = template.students.sorted {
                    $0.name.localizedCompare($1.name) == .orderedAscending
                }
                
                let updatedTemplate = EasyGrade.ExamTemplate(
                    id: template.id,
                    name: template.name,
                    date: template.date,
                    numberOfQuestions: template.numberOfQuestions,
                    numberOfAnswersPerQuestion: template.numberOfAnswersPerQuestion,
                    scoreCorrectAnswer: template.scoreCorrectAnswer,
                    penaltyIncorrectAnswer: template.penaltyIncorrectAnswer,
                    penaltyBlankAnswer: template.penaltyBlankAnswer,
                    cancelledQuestions: template.cancelledQuestions,
                    correctAnswerMatrix: template.correctAnswerMatrix,
                    students: sortedStudents,
                    evaluatedStudents: !reevaluatedStudents.isEmpty ? reevaluatedStudents : template.evaluatedStudents
                )
                
                try await updateExamTemplateUseCase.execute(template: updatedTemplate)
                
            } catch {
                errorMessage = "Error al actualizar la plantilla: \(error.localizedDescription)"
            }
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
                print(students)
            case .failure(let error):
                errorMessage = "Error al importar estudiantes: \(error.localizedDescription)"
            }
        }
    }
}
