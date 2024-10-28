
import Foundation
import CoreImage

protocol CameraRepositoryType {
    func requestCameraPermission() async throws -> Bool
    func startCaptureSession()
    func stopCaptureSession()
    func captureImage() async throws -> CGImage?
}
