
import Foundation

class StopCaptureSessionUseCase: StopCaptureSessionUseCaseType {
    
    let repository: CameraRepository
    
    init(repository: CameraRepository) {
        self.repository = repository
    }
    
    func execute() {
        repository.stopCaptureSession()
    }
}
