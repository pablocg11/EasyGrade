
import Foundation

class CameraUsageFactory {
    
    func createView () -> CameraView {
        return CameraView(viewmodel: createCameraViewModel())
    }
    
    private func createCameraViewModel() -> CameraViewModel {
        return CameraViewModel(requestCameraPermissionUseCase: createRequestCameraPermissionUseCase(),
                               startCaptureSessionUseCase: createStartCaptureSessionUseCase(),
                               stopCaptureSessionUseCase: createStopCaptureSessionUseCase(),
                               captureImageUseCase: createCaptureImageUseCase())
    }
    
    private func createRequestCameraPermissionUseCase() -> RequestCameraPermissionUseCaseType {
        return RequestCameraPermissionUseCase(repository: createCameraRepository())
    }
    
    private func createStartCaptureSessionUseCase() -> StartCaptureSessionUseCaseType {
        return StartCaptureSessionUseCase(repository: createCameraRepository())
    }
    
    private func createStopCaptureSessionUseCase() -> StopCaptureSessionUseCaseType {
        return StopCaptureSessionUseCase(repository: createCameraRepository())
    }
    
    private func createCaptureImageUseCase() -> CaptureImageUseCaseType {
        return CaptureImageUseCase(repository: createCameraRepository())
    }
    
    private func createCameraRepository() -> CameraRepository {
        return CameraRepository(frameHandler: createFrameHandler())
    }
    
    private func createFrameHandler() -> FrameHandler {
        return FrameHandler()
    }
    
    
}
