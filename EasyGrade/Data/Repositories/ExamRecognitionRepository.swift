
import Foundation
import Vision

protocol ExamRecognitionRepositoryProtocol {
    func recognizeExamData(from image: CGImage, template: AnswerTemplate) async throws -> Result<(name: String?, dni: String?, recognizedAnswers: String?), any Error>
}

class ExamRecognitionRepository: ExamRecognitionRepositoryProtocol {
    
    func recognizeExamData(from image: CGImage, template: AnswerTemplate) async throws -> Result<(name: String?, dni: String?, recognizedAnswers: String?), any Error> {
        return try await withCheckedThrowingContinuation { continuation in
            let requestHandler = VNImageRequestHandler(cgImage: image)
            let recognizeTextRequest = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: ExamRecognitionError.noResults)
                    return
                }
                
                var recognizedName: String?
                var recognizedDNI: String?
                var recognizedAnswers: String?
                
                for observation in observations {
                    guard let recognizedText = observation.topCandidates(1).first?.string else { continue }
                    
                    if let name = self.extractData(from: recognizedText, prefix: "apellidos y nombre:") {
                        recognizedName = name
                    }
                    
                    if let dni = self.extractData(from: recognizedText, prefix: "dni:") {
                        recognizedDNI = dni
                    }
                    
                    if let answers = self.extractData(from: recognizedText, prefix: "respuestas:") {
                        let cleanedAnswers = answers.replacingOccurrences(of: " ", with: "")
                        recognizedAnswers = cleanedAnswers
                        
                        if cleanedAnswers.count != template.numberOfQuestions {
                            continuation.resume(
                                throwing: ExamRecognitionError.invalidAnswersCount(
                                    expected: Int(template.numberOfQuestions),
                                    actual: cleanedAnswers.count
                                )
                            )
                            return
                        }
                    }
                }
                
                continuation.resume(returning: .success((recognizedName, recognizedDNI, recognizedAnswers)))
            }
            
            do {
                try requestHandler.perform([recognizeTextRequest])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func extractData(from text: String, prefix: String) -> String? {
        guard text.lowercased().contains(prefix) else { return nil }
        let components = text.components(separatedBy: ":")
        guard components.count > 1 else { return nil }
        return components[1].trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
