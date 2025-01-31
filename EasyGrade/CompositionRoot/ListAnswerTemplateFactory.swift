
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
                                         updateEvaluatedStudentScoreUseCase: createUpdateEvaluatedStudentScoreUseCase(),
                                         importStudentListFromCSV: createImportStudentListFromCSV(),
                                         reEvaluatedStudentListUseCase: createReEvaluateStudentListUseCase())
    }
    
    private func createDeleteViewModel() -> DeleteExamTemplateViewModel {
        return DeleteExamTemplateViewModel(deleteExamTemplateUseCase: createDeleteExamTemplateUseCase())
    }
    
    private func createListEvaluatedStudentsViewModel() -> ListEvaluatedStudentsViewModel {
        return ListEvaluatedStudentsViewModel(fetchEvaluatedStudentsUseCase: createFetchEvaluatedStudentsUseCase(),
                                              updateEvaluatedStudentUseCase: createUpdateEvaluatedStudentUseCase(),
                                              deleteEvaluatedStudentUseCase: createDeleteEvaluatedStudentUseCase(),
                                              exportEvaluatedStudentsFileUseCase: createExportEvaluatedStudentsFileUseCase())
    }
    
    private func createExamCorrectionUseCase() -> CorrectExamUseCaseProtocol {
        return CorrectExamUseCase(service: ExamCorrectionService())
    }
    
    private func createUpdateEvaluatedStudentScoreUseCase() -> UpdateEvaluatedStudentScoreUseCaseProtocol {
        return UpdateEvaluatedStudentScoreUseCase(repository: EvaluatedStudentRepository())
    }
    
    private func createFetchEvaluatedStudentsUseCase() -> FetchEvaluatedStudentsUseCaseProtocol {
        return FetchEvaluatedStudentsUseCase(repository: EvaluatedStudentRepository())
    }
    
    private func createUpdateEvaluatedStudentUseCase() -> UpdateEvaluatedStudentScoreUseCaseProtocol {
        return UpdateEvaluatedStudentScoreUseCase(repository: EvaluatedStudentRepository())
    }
    
    private func createDeleteEvaluatedStudentUseCase() -> DeleteEvaluatedStudentUseCaseProtocol {
        return DeleteEvaluatedStudentUseCase(repository: EvaluatedStudentRepository())
    }
    
    private func createExportEvaluatedStudentsFileUseCase() -> ExportEvaluatedStudentsFileUseCaseProtocol {
        return ExportEvaluatedStudentsFileUseCase(repository: EvaluatedStudentRepository())
    }
    
    private func createUpdateExamTemplateUseCase() -> UpdateExamTemplateUseCaseProtocol {
        return UpdateExamTemplateUseCase(ExamTemplateRepository: ExamTemplateRepository())
    }

    private func createDeleteExamTemplateUseCase() -> DeleteExamTemplateUseCaseProtocol {
        return DeleteExamTemplateUseCase(ExamTemplateRepository: ExamTemplateRepository())
    }
    
    private func createImportStudentListFromCSV() -> ImportStudentListFromCSVProtocol {
        return ImportStudentListFromCSV(repository: createStudentRepository())
    }
    
    private func createReEvaluateStudentListUseCase() -> ReevaluateStudentListUseCaseProtocol {
        return ReevaluateStudentListUseCase(service: ExamCorrectionService())
    }
    
    private func createViewModel() -> ListExamTemplateViewModel {
        return ListExamTemplateViewModel(getExamTemplateListUseCase: createGetExamTemplateListUseCase())
    }
    
    private func createGetExamTemplateListUseCase() -> GetExamTemplateListUseCaseProtocol {
        return GetExamTemplateListUseCase(ExamTemplateRepository: ExamTemplateRepository())
    }
    
    private func createStudentRepository() -> StudentRepositoryProtocol {
        return StudentRepository(studentImportService: StudentImportService(),
                                 studentMatchingService: StudentMatchingService())
    }
}
