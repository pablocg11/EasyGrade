
import Foundation
import CoreImage

protocol UseCameraUseCaseType {
    func execute() async throws -> CGImage
}
