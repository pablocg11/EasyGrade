
import Foundation

class EvaluatedStudentFactory {
    
    func createView(for template: AnswerTemplate) -> RecognitionView {
        return RecognitionView(template: template,
                               viewModel: createViewModel(),
                               examCorrectionViewModel: createExamCorrectionViewModel())
    }
    
    private func createViewModel() -> ExamDataRecognitionViewModel {
        return ExamDataRecognitionViewModel(recognizeExamDataUseCase: createRecognizeTextUseCase(),
                                            saveEvaluatedStudentUseCase: createSaveEvaluatedStudentUseCase())
    }
    
    private func createExamCorrectionViewModel() -> ExamCorrectionViewModel {
        return ExamCorrectionViewModel(examCorrectionUseCase: createExamCorrectionUseCase())
    }
    
    private func createExamCorrectionUseCase() -> CorrectExamUseCase {
        return CorrectExamUseCase(repository: createExamCorrectionRepository())
    }
    
    private func createSaveEvaluatedStudentUseCase() -> SaveEvaluatedStudentUseCase {
        return SaveEvaluatedStudentUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createExamCorrectionRepository() -> ExamCorrectionRepository {
        return ExamCorrectionRepository()
    }
    
    private func createEvaluatedStudentRepository() -> EvaluatedStudentRepository {
        return EvaluatedStudentRepository()
    }
    
    private func createRecognizeTextUseCase() -> RecognizeExamDataUseCase {
        return RecognizeExamDataUseCase(repository: createTextRecognitionRepository())
    }
    
    private func createTextRecognitionRepository() -> ExamRecognitionRepository {
        return ExamRecognitionRepository()
    }
}
