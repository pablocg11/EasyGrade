
import Combine
import UIKit
import Vision

class AnswerRecognitionRepositoryImpl: AnswerRecognitionRepository {
    
    private let visionHandler: VisionHandler
    
    init(visionHandler: VisionHandler) {
        self.visionHandler = visionHandler
    }
    
    func detectRectangles(in image: CGImage) -> AnyPublisher<[VNRectangleObservation], Error> {
        return visionHandler.detectRectangles(in: image)
            .eraseToAnyPublisher()
    }
    
    func detectMarks(in rectangles: [VNRectangleObservation], image: CGImage) -> AnyPublisher<[Bool], Error> {
        return visionHandler.detectMarks(in: rectangles, image: image)
            .eraseToAnyPublisher()
    }
}
