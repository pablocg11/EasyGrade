
import Foundation
import AVFoundation
import CoreImage

class CameraRepository: CameraRepositoryType {
    
    private let frameHandler: FrameHandler
    
    init(frameHandler: FrameHandler) {
        self.frameHandler = frameHandler
    }
    
    func requestCameraPermission() async throws -> Bool {
        let granted = await frameHandler.checkPermission()
        guard granted else {
            throw CameraError.permissionDenied
        }
        return granted
    }
    
    func startCaptureSession() {
        frameHandler.startCaptureSession()
    }
    
    func stopCaptureSession() {
        frameHandler.stopCaptureSession()
    }
    
    func captureImage() async throws -> CGImage? {
        guard let image = await frameHandler.captureImage() else {
            throw CameraError.captureFailed
        }
        return image
    }
}

