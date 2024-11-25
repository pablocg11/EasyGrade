
import Foundation

class EvaluatedStudentFactory {
    
    func createView(for template: AnswerTemplate) -> RecognitionView {
        return RecognitionView(template: template, viewModel: createViewModel())
    }
    
    private func createViewModel() -> ExamDataRecognitionViewModel {
        return ExamDataRecognitionViewModel(recognizeExamDataUseCase: createRecognizeTextUseCase())
    }
    
    private func createRecognizeTextUseCase() -> RecognizeExamDataUseCase {
        return RecognizeExamDataUseCase(repository: createTextRecognitionRepository())
    }
    
    private func createTextRecognitionRepository() -> ExamRecognitionRepository {
        return ExamRecognitionRepository()
    }
}
