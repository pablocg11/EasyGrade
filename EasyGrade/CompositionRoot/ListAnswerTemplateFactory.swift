
import Foundation

class ListAnswerTemplateFactory {
    
    func createView() -> AnswerTemplateListView {
        return AnswerTemplateListView(viewModel: createViewModel(), 
                                      editViewModel: createEditViewModel(),
                                      deleteViewModel: createDeleteViewModel())
    }
    
    private func createEditViewModel() -> EditAnswerTemplateViewModel {
        return EditAnswerTemplateViewModel(updateAnswerTemplateUseCase: createUpdateAnswerTemplateUseCase())
    }
    
    private func createDeleteViewModel() -> DeleteAnswerTemplateViewModel {
        return DeleteAnswerTemplateViewModel(deleteAnswerTemplateUseCase: createDeleteAnswerTemplateUseCase())
    }
    
    private func createUpdateAnswerTemplateUseCase() -> UpdateAnswerTemplateUseCaseType {
        return UpdateAnswerTemplateUseCase(answerTemplateRepository: createRepository())
    }
    
    private func createDeleteAnswerTemplateUseCase() -> DeleteAnswerTemplateUseCaseType {
        return DeleteAnswerTemplateUseCase(answerTemplateRepository: createRepository())
    }
    
    private func createViewModel() -> ListAnswerTemplateViewModel {
        return ListAnswerTemplateViewModel(getAnswerTemplatesUseCase: createListAnswerTemplateUseCase())
    }
    
    private func createListAnswerTemplateUseCase() -> GetAnswerTemplatesUseCaseType {
        return GetAnswerTemplatesUseCase(answerTemplateRepository: createRepository())
    }

    private func createRepository() -> AnswerTemplateRepository {
        return AnswerTemplateRepository()
    }
    
}
