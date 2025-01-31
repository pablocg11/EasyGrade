
import Foundation

class EvaluatedStudentFactory {
    
    func createView(for template: ExamTemplate) -> RecognitionView {
        return RecognitionView(template: template,
                               examCorrectionViewModel: createExamCorrectionViewModel(),
                               cameraViewModel: createCameraViewModel())
    }
    
    private func createExamCorrectionViewModel() -> ExamCorrectionViewModel {
        return ExamCorrectionViewModel(examCorrectionUseCase: createExamCorrectionUseCase(),
                                       mathStudentUseCase: createMatchStudentUseCase(),
                                       saveEvaluatedStudentUseCase: createSaveEvaluatedStudentUseCase())
    }
    
    private func createCameraViewModel() -> CameraViewModel {
        return CameraViewModel(recognizeExamDataUseCase: createRecognizeExamDataUseCase())
    }
    
    private func createExamCorrectionUseCase() -> CorrectExamUseCaseProtocol {
        return CorrectExamUseCase(service: ExamCorrectionService())
    }
    
    private func createMatchStudentUseCase() -> MatchStudentUseCaseProtocol {
        return MatchStudentUseCase(studentMatchingService: StudentMatchingService())
    }
    
    private func createSaveEvaluatedStudentUseCase() -> SaveEvaluatedStudentUseCaseProtocol {
        return SaveEvaluatedStudentUseCase(repository: createEvaluatedStudentRepository())
    }

    private func createEvaluatedStudentRepository() -> EvaluatedStudentRepository {
        return EvaluatedStudentRepository()
    }
    
    private func createRecognizeExamDataUseCase() -> RecognizeExamDataUseCaseProtocol {
        return RecognizeExamDataUseCase(service: ExamDataProcessingService())
    }
}
