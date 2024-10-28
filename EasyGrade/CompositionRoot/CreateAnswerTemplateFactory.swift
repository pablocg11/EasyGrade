
import Foundation

class CreateAnswerTemplateFactory {
    
    func createView() -> CreateAnswerTemplateView {
        return CreateAnswerTemplateView(viewModel: createViewModel())
    }
    
    private func createViewModel() -> CreateAnswerTemplateViewModel {
        return CreateAnswerTemplateViewModel(createAnswerTemplateUseCase: createCreateAnswerTemplateUseCase())
    }
    
    private func createCreateAnswerTemplateUseCase() -> CreateAnswerTemplateUseCase {
        return CreateAnswerTemplateUseCase(answerTemplateRepository: createRepository())
    }

    private func createRepository() -> AnswerTemplateRepository {
        return AnswerTemplateRepository()
    }
    
}
