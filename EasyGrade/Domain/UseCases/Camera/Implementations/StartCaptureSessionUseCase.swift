
import Foundation

class StartCaptureSessionUseCase: StartCaptureSessionUseCaseType {
    
    let repository: CameraRepository
    
    init(repository: CameraRepository) {
        self.repository = repository
    }
    
    func execute() {
        repository.startCaptureSession()
    }
}
