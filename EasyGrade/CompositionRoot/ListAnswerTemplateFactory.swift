
import Foundation

class ListAnswerTemplateFactory {
    
    func createView() -> AnswerTemplateListView {
        return AnswerTemplateListView(viewModel: createViewModel(), 
                                      editViewModel: createEditViewModel(),
                                      deleteViewModel: createDeleteViewModel(),
                                      listEvaluatedStudentsViewModel: createListEvaluatedStudentsViewModel())
    }
    
    private func createEditViewModel() -> EditAnswerTemplateViewModel {
        return EditAnswerTemplateViewModel(updateAnswerTemplateUseCase: createUpdateAnswerTemplateUseCase())
    }
    
    private func createDeleteViewModel() -> DeleteAnswerTemplateViewModel {
        return DeleteAnswerTemplateViewModel(deleteAnswerTemplateUseCase: createDeleteAnswerTemplateUseCase())
    }
    
    private func createListEvaluatedStudentsViewModel() -> ListEvaluatedStudentsViewModel {
        return ListEvaluatedStudentsViewModel(fetchEvaluatedStudentsUseCase: createFetchEvaluatedStudentsUseCase(),
                                              deleteEvaluatedStudentUseCase: createDeleteEvaluatedStudentUseCase(),
                                              exportEvaluatedStudentsFileUseCase: createExportEvaluatedStudentsFileUseCase())
    }
    
    private func createFetchEvaluatedStudentsUseCase() -> FetchEvaluatedStudentsUseCase {
        return FetchEvaluatedStudentsUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createDeleteEvaluatedStudentUseCase() -> DeleteEvaluatedStudentUseCase {
        return DeleteEvaluatedStudentUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createExportEvaluatedStudentsFileUseCase() -> ExportEvaluatedStudentsFileUseCase {
        return ExportEvaluatedStudentsFileUseCase(repository: createEvaluatedStudentRepository())
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
    
    private func createEvaluatedStudentRepository() -> EvaluatedStudentRepository {
        return EvaluatedStudentRepository()
    }

    private func createRepository() -> AnswerTemplateRepository {
        return AnswerTemplateRepository()
    }
    
}
