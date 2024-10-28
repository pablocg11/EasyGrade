
import Foundation
import CoreImage

class CameraViewModel: ObservableObject {
    
    private let requestCameraPermissionUseCase: RequestCameraPermissionUseCaseType
    private let startCaptureSessionUseCase: StartCaptureSessionUseCaseType
    private let stopCaptureSessionUseCase: StopCaptureSessionUseCaseType
    private let captureImageUseCase: CaptureImageUseCaseType
    
    @Published var image: CGImage?
    @Published var isCameraAccessible: Bool = false
    @Published var showLoading: Bool = false
    @Published var errorMessage: String?
    
    init(requestCameraPermissionUseCase: RequestCameraPermissionUseCaseType,
         startCaptureSessionUseCase: StartCaptureSessionUseCaseType,
         stopCaptureSessionUseCase: StopCaptureSessionUseCaseType,
         captureImageUseCase: CaptureImageUseCaseType) {
        
        self.requestCameraPermissionUseCase = requestCameraPermissionUseCase
        self.startCaptureSessionUseCase = startCaptureSessionUseCase
        self.stopCaptureSessionUseCase = stopCaptureSessionUseCase
        self.captureImageUseCase = captureImageUseCase
    }

    func checkCameraPermission() {
        Task { @MainActor in
            showLoading = true
            do {
                isCameraAccessible = try await requestCameraPermissionUseCase.execute()
            } catch {
                errorMessage = "Error al verificar el acceso a la cámara: \(error.localizedDescription)"
            }
            showLoading = false
        }
    }
    
    func startCaptureSession() {
        Task { @MainActor in
            startCaptureSessionUseCase.execute()
        }
    }

    func stopCaptureSession() {
        Task { @MainActor in
            stopCaptureSessionUseCase.execute()
        }
    }
    
    func takePhoto() async {
        await MainActor.run {
            showLoading = true
        }
        do {
            let capturedImage = try await captureImageUseCase.execute()
            await MainActor.run {
                image = capturedImage
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error al capturar la imagen: \(error.localizedDescription)"
            }
        }
        await MainActor.run {
            showLoading = false
        }
    }
}
