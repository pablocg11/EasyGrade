
import Foundation

class ListExamTemplateFactory {
    
    func createView() -> ExamTemplateListView {
        return ExamTemplateListView(viewModel: createViewModel(), 
                                      editViewModel: createEditViewModel(),
                                      deleteViewModel: createDeleteViewModel(),
                                      listEvaluatedStudentsViewModel: createListEvaluatedStudentsViewModel())
    }
    
    private func createEditViewModel() -> EditExamTemplateViewModel {
        return EditExamTemplateViewModel(updateExamTemplateUseCase: createUpdateExamTemplateUseCase(),
                                           correctExamUseCase: createExamCorrectionUseCase(),
                                           updateEvaluatedStudentScoreUseCase: createUpdateEvaluatedStudentScoreUseCase())
    }
    
    private func createDeleteViewModel() -> DeleteExamTemplateViewModel {
        return DeleteExamTemplateViewModel(deleteExamTemplateUseCase: createDeleteExamTemplateUseCase())
    }
    
    private func createListEvaluatedStudentsViewModel() -> ListEvaluatedStudentsViewModel {
        return ListEvaluatedStudentsViewModel(fetchEvaluatedStudentsUseCase: createFetchEvaluatedStudentsUseCase(),
                                              deleteEvaluatedStudentUseCase: createDeleteEvaluatedStudentUseCase(),
                                              exportEvaluatedStudentsFileUseCase: createExportEvaluatedStudentsFileUseCase())
    }
    
    private func createExamCorrectionUseCase() -> CorrectExamUseCaseProtocol {
        return CorrectExamUseCase(service: createExamCorrectionService())
    }
    
    private func createUpdateEvaluatedStudentScoreUseCase() -> UpdateEvaluatedStudentScoreUseCaseProtocol {
        return UpdateEvaluatedStudentScoreUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createFetchEvaluatedStudentsUseCase() -> FetchEvaluatedStudentsUseCaseProtocol {
        return FetchEvaluatedStudentsUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createDeleteEvaluatedStudentUseCase() -> DeleteEvaluatedStudentUseCaseProtocol {
        return DeleteEvaluatedStudentUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createExportEvaluatedStudentsFileUseCase() -> ExportEvaluatedStudentsFileUseCaseProtocol {
        return ExportEvaluatedStudentsFileUseCase(repository: createEvaluatedStudentRepository())
    }
    
    private func createUpdateExamTemplateUseCase() -> UpdateExamTemplateUseCaseProtocol {
        return UpdateExamTemplateUseCase(ExamTemplateRepository: createRepository())
    }

    private func createDeleteExamTemplateUseCase() -> DeleteExamTemplateUseCaseProtocol {
        return DeleteExamTemplateUseCase(ExamTemplateRepository: createRepository())
    }
    
    private func createViewModel() -> ListExamTemplateViewModel {
        return ListExamTemplateViewModel(getExamTemplatesUseCase: createListExamTemplateUseCase())
    }
    
    private func createListExamTemplateUseCase() -> GetExamTemplatesUseCaseProtocol {
        return GetExamTemplatesUseCase(ExamTemplateRepository: createRepository())
    }
    
    private func createEvaluatedStudentRepository() -> EvaluatedStudentRepositoryProtocol {
        return EvaluatedStudentRepository()
    }
    
    private func createExamCorrectionService() -> ExamCorrectionServiceProtocol {
        return ExamCorrectionService()
    }

    private func createRepository() -> ExamTemplateRepository {
        return ExamTemplateRepository()
    }
    
}
