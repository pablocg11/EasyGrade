
import Foundation
import CoreGraphics

class ExamDataRecognitionViewModel: ObservableObject {
    private let recognizeExamDataUseCase: RecognizeExamDataUseCase
    
    @Published var recognizedStudents: [EvaluatedStudent] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var currentlyRecognizedStudent: EvaluatedStudent?
    @Published var recognizedAnswers: String?
    
    init(recognizeExamDataUseCase: RecognizeExamDataUseCase) {
        self.recognizeExamDataUseCase = recognizeExamDataUseCase
    }
    
    func recognizeExamData(with image: CGImage, template: AnswerTemplate) {
        isLoading = true
        
        Task {
            let result = try await self.recognizeExamDataUseCase.execute(image: image,
                                                                         template: template)
            await self.handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<(name: String?, dni: String?, recognizedAnswers: String?), Error>) async {
        switch result {
        case .success(let (name, dni, recognizedAnswers)):
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = nil
                if let studentDni = dni, let studentName = name, let recognizedAnswers {
                    self.currentlyRecognizedStudent = EvaluatedStudent(dni: studentDni, name: studentName)
                    self.recognizedAnswers = recognizedAnswers
                }
            }
        case .failure(let error):
            await handleError(error)
        }
    }
    
    private func handleError(_ error: Error) async {
        await MainActor.run {
            self.isLoading = false
            self.errorMessage = "Error al reconocer los datos: \(error.localizedDescription)"
        }
    }
}
