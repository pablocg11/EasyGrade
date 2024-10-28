
import Foundation
import AVFoundation

enum CameraError: Error {
    case permissionDenied
    case captureFailed
    case unknownError(String)

    var localizedDescription: String {
        switch self {
        case .permissionDenied:
            return "Acceso a la cámara denegado."
        case .captureFailed:
            return "No se pudo capturar la imagen."
        case .unknownError(let message):
            return message
        }
    }
}
