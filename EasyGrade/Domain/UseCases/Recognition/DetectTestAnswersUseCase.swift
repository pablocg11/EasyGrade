
import Foundation
import CoreGraphics

protocol DetectTestAnswersUseCaseProtocol {
    func execute(image: CGImage, numberOfQuestions: Int, numberOfAnswers: Int, brightnessThreshold: Int) async throws -> [[Bool]]
}

class DetectTestAnswersUseCase: DetectTestAnswersUseCaseProtocol {
    private let repository: TestAnswerDetectionRepository

    init(repository: TestAnswerDetectionRepository) {
        self.repository = repository
    }

    func execute(image: CGImage, numberOfQuestions: Int, numberOfAnswers: Int, brightnessThreshold: Int) async throws -> [[Bool]] {
        return try await repository.detectAnswers(
            from: image,
            numberOfQuestions: numberOfQuestions,
            numberOfAnswers: numberOfAnswers,
            brightnessThreshold: brightnessThreshold
        )
    }
}
