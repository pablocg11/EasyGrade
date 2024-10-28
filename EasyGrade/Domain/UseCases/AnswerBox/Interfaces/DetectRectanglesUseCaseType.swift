
import Foundation
import Vision
import Combine
import UIKit

protocol DetectRectanglesUseCaseType {
    func execute(image: CGImage) -> AnyPublisher<[VNRectangleObservation], Error>
}
