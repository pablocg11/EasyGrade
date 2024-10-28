
import Foundation
import Combine
import UIKit
import Vision


class DetectMarksInRectanglesUseCase: DetectMarksInRectanglesUseCaseType {
    
    let repository: AnswerRecognitionRepository
    
    init(repository: AnswerRecognitionRepository) {
        self.repository = repository
    }
    
    func execute(rectangles: [VNRectangleObservation], image: CGImage) -> AnyPublisher<[Bool], any Error> {
        return repository.detectMarks(in: rectangles, image: image)
    }
}
