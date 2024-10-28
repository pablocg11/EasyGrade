
import Foundation
import CoreImage

class CaptureImageUseCase: CaptureImageUseCaseType {
    
    let repository: CameraRepository
    
    init(repository: CameraRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> CGImage? {
        try await repository.captureImage()
    }
}
