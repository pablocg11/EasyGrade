
import Foundation

protocol RequestCameraPermissionUseCaseType {
    
    func execute() async throws -> Bool
}
