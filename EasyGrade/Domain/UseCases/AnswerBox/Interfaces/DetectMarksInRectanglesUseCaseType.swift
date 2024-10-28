
import Foundation
import Vision
import Combine
import UIKit

protocol DetectMarksInRectanglesUseCaseType {
    func execute(rectangles: [VNRectangleObservation], image: CGImage) -> AnyPublisher<[Bool], Error>
}
