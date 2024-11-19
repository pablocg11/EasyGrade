
import Foundation
import Vision

protocol RecognizeTextUseCaseProtocol {
    func execute(image: CGImage) async throws -> (name: String?, dni: String?)
}

class RecognizeTextUseCase: RecognizeTextUseCaseProtocol {
    private let repository: TextRecognitionRepository

    init(repository: TextRecognitionRepository) {
        self.repository = repository
    }

    func execute(image: CGImage) async throws -> (name: String?, dni: String?) {
        return try await repository.recognizeText(from: image)
    }
}

