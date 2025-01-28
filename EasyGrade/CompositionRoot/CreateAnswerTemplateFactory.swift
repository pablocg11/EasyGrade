
import Foundation

class CreateExamTemplateFactory {
    
    func createView() -> CreateExamTemplateView {
        return CreateExamTemplateView(viewModel: createViewModel())
    }
    
    private func createViewModel() -> CreateExamTemplateViewModel {
        return CreateExamTemplateViewModel(createExamTemplateUseCase: createCreateExamTemplateUseCase())
    }
    
    private func createCreateExamTemplateUseCase() -> CreateExamTemplateUseCase {
        return CreateExamTemplateUseCase(ExamTemplateRepository: createRepository())
    }

    private func createRepository() -> ExamTemplateRepository {
        return ExamTemplateRepository()
    }
    
}
