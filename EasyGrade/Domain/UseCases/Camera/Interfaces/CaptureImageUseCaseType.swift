
import Foundation
import CoreImage

protocol CaptureImageUseCaseType {
    
    func execute() async throws -> CGImage?
}
