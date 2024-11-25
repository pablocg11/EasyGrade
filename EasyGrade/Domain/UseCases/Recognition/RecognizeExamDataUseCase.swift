
import Foundation
import Vision

protocol RecognizeExamDataUseCaseProtocol {
    func execute(image: CGImage, template: AnswerTemplate) async throws -> Result<(name: String?, dni: String?, recognizedAnswers: String?), Error>
}

class RecognizeExamDataUseCase: RecognizeExamDataUseCaseProtocol {
    private let repository: ExamRecognitionRepository

    init(repository: ExamRecognitionRepository) {
        self.repository = repository
    }

    func execute(image: CGImage, template: AnswerTemplate) async throws -> Result<(name: String?, dni: String?, recognizedAnswers: String?), Error> {
        return try await repository.recognizeExamData(from: image, template: template)
    }
}

