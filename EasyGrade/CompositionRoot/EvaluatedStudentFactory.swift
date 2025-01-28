
import Foundation

class EvaluatedStudentFactory {
    
    func createView(for template: ExamTemplate) -> RecognitionView {
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
    
    private func createExamCorrectionUseCase() -> CorrectExamUseCaseProtocol {
        return CorrectExamUseCase(service: createExamCorrectionService())
    }
    
    private func createSaveEvaluatedStudentUseCase() -> SaveEvaluatedStudentUseCaseProtocol {
        return SaveEvaluatedStudentUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createExamCorrectionService() -> ExamCorrectionServiceProtocol{
        return ExamCorrectionService()
    }
    
    private func createEvaluatedStudentRepository() -> EvaluatedStudentRepository {
        return EvaluatedStudentRepository()
    }
    
    private func createRecognizeExamDataUseCase() -> RecognizeExamDataUseCaseProtocol {
        return RecognizeExamDataUseCase(service: ExamDataProcessingService())
    }
}
