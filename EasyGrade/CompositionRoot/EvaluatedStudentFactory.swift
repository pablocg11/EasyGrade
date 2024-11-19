
import Foundation

class EvaluatedStudentFactory {
    
    func createView() -> ContentView {
        return ContentView(viewModel: createViewModel())
    }
    
    private func createViewModel() -> StudentRecognitionViewModel {
        return StudentRecognitionViewModel(
            recognizeTextUseCase: createRecognizeTextUseCase(),
            fetchEvaluateStudents: createFetchEvaluatedStudentsUseCase(),
            saveStudentUseCase: createSaveEvaluatedStudentUseCase(),
            testAnswersDetectionUseCase: createDetectTestAnswersUseCase()
        )
    }
    
    private func createSaveEvaluatedStudentUseCase() -> SaveEvaluatedStudentUseCase {
        return SaveEvaluatedStudentUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createFetchEvaluatedStudentsUseCase() -> FetchEvaluatedStudentsUseCase {
        return FetchEvaluatedStudentsUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createRecognizeTextUseCase() -> RecognizeTextUseCase {
        return RecognizeTextUseCase(repository: createTextRecognitionRepository())
    }
    
    private func createDetectTestAnswersUseCase() -> DetectTestAnswersUseCase {
        return DetectTestAnswersUseCase(repository: createTestAnswersRepository())
    }
    
    private func createTextRecognitionRepository() -> TextRecognitionRepository {
        return TextRecognitionRepository()
    }
    
    private func createTestAnswersRepository() -> TestAnswerDetectionRepository {
        return TestAnswerDetectionRepository()
    }
    
    private func createEvaluatedStudentRepository() -> EvaluatedStudentRepository {
        return CoredDataEvaluatedStudentRepository(context: PersistenceController.shared.container.viewContext)
    }
}
