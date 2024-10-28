
import Foundation

class RequestCameraPermissionUseCase: RequestCameraPermissionUseCaseType {
   
    let repository: CameraRepository
    
    init(repository: CameraRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        return try await repository.requestCameraPermission()
    }
    
}
