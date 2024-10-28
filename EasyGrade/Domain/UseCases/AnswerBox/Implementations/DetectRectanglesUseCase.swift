
import Foundation
import Combine
import UIKit
import Vision

class DetectRectanglesUseCase: DetectRectanglesUseCaseType {
    
    let repository: AnswerRecognitionRepository
    
    init(repository: AnswerRecognitionRepository) {
        self.repository = repository
    }
    
    func execute(image: CGImage) -> AnyPublisher<[VNRectangleObservation], any Error> {
        repository.detectRectangles(in: image)
    }
}
