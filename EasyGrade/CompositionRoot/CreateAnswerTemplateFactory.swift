
import Foundation

class CreateExamTemplateFactory {
    
    func createView() -> CreateExamTemplateView {
        return CreateExamTemplateView(viewModel: createViewModel())
    }
    
    private func createViewModel() -> CreateExamTemplateViewModel {
        return CreateExamTemplateViewModel(createExamTemplateUseCase: createCreateExamTemplateUseCase(),
                                           importStudentListFromCSV: createImportStudentListFromCSV())
    }
    
    private func createCreateExamTemplateUseCase() -> CreateExamTemplateUseCase {
        return CreateExamTemplateUseCase(ExamTemplateRepository: createRepository())
    }
    
    private func createImportStudentListFromCSV() -> ImportStudentListFromCSVProtocol {
        return ImportStudentListFromCSV(repository: createStudentRespository())
    }
    
    private func createStudentRespository() -> StudentRepository {
        return StudentRepository(studentImportService: StudentImportService(),
                                 studentMatchingService: StudentMatchingService())
    }
    
    private func createRepository() -> ExamTemplateRepository {
        return ExamTemplateRepository()
    }
    
}
