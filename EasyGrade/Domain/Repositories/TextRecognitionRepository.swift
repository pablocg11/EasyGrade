
import Foundation
import Vision

protocol TextRecognitionRepositoryProtocol {
    func recognizeText(from image: CGImage) async throws -> (name: String?, dni: String?)
}

class TextRecognitionRepository: TextRecognitionRepositoryProtocol {
    
    func recognizeText(from image: CGImage) async throws -> (name: String?, dni: String?) {
        return try await withCheckedThrowingContinuation { continuation in
            let requestHandler = VNImageRequestHandler(cgImage: image)
            let recognizeTextRequest = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: (nil, nil))
                    return
                }
                
                var recognizedName: String?
                var recognizedDNI: String?
                
                for observation in observations {
                    guard let recognizedText = observation.topCandidates(1).first?.string else { continue }
                    
                    if recognizedText.lowercased().contains("apellidos y nombre:") {
                        let components = recognizedText.components(separatedBy: ":")
                        if components.count > 1 {
                            recognizedName = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                    
                    if recognizedText.lowercased().contains("dni:") {
                        let components = recognizedText.components(separatedBy: ":")
                        if components.count > 1 {
                            recognizedDNI = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                }
                
                continuation.resume(returning: (recognizedName, recognizedDNI))
            }
            
            do {
                try requestHandler.perform([recognizeTextRequest])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
