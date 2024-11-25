
import Foundation

class ExamCorrectionFactory {
    
    func createView(student: EvaluatedStudent, template: AnswerTemplate, studentAnswers: String) -> ExamCorrectionView {
        return ExamCorrectionView(viewmodel: createViewModel(),
                                  student: student,
                                  template: template,
                                  studentAnswers: studentAnswers)
    }
    
    private func createViewModel() -> ExamCorrectionViewModel {
        return ExamCorrectionViewModel(examCorrectionUseCase: createExamCorrectionUseCase())
    }
    
    private func createExamCorrectionUseCase() -> CorrectExamUseCase {
        return CorrectExamUseCase(repository: createRepository())
    }
    
    private func createRepository() -> ExamCorrectionRepository {
        return ExamCorrectionRepository()
    }
}
