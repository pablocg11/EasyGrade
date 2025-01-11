
import Foundation

class EvaluatedStudentFactory {
    
    func createView(for template: AnswerTemplate) -> RecognitionView {
        return RecognitionView(template: template,
                               examCorrectionViewModel: createExamCorrectionViewModel(),
                               cameraViewModel: createCameraViewModel())
    }
    
    private func createExamCorrectionViewModel() -> ExamCorrectionViewModel {
        return ExamCorrectionViewModel(examCorrectionUseCase: createExamCorrectionUseCase(),
                                       saveEvaluatedStudentUseCase: createSaveEvaluatedStudentUseCase())
    }
    
    private func createCameraViewModel() -> CameraViewModel {
        return CameraViewModel(recognizeExamDataUseCase: createRecognizeExamDataUseCase())
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
    
    private func createRecognizeExamDataUseCase() -> RecognizeExamDataUseCase {
        return RecognizeExamDataUseCase(processor: ExamDataProcessor())
    }
}
