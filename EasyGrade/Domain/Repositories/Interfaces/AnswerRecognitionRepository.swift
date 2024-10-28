
import Combine
import UIKit
import Vision

protocol AnswerRecognitionRepository {
    func detectRectangles(in image: CGImage) -> AnyPublisher<[VNRectangleObservation], Error>
    func detectMarks(in rectangles: [VNRectangleObservation], image: CGImage) -> AnyPublisher<[Bool], Error>
}
