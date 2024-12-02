
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
                
                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    continuation.resume(returning: .failure(ExamRecognitionError.noResults))
                    return
                }
                
                var recognizedName: String?
                var recognizedDNI: String?
                var recognizedAnswers: String?
                
                for observation in observations {
                    guard let recognizedText = observation.topCandidates(1).first?.string else { continue }
                                        
                    if let name = self.extractData(from: recognizedText, patterns: [
                        "(?i)apellidos y nombre:\\s*(.+)",
                        "(?i)nombre y apellidos:\\s*(.+)"
                    ], removeSpaces: false) {
                        recognizedName = name.uppercased()
                    }

                    if let dni = self.extractData(from: recognizedText, patterns: [
                        "(?i)dni:\\s*([0-9A-Z\\s]+)"
                    ], removeSpaces: true) {
                        recognizedDNI = dni.uppercased()
                    }

                    if let answers = self.extractData(from: recognizedText, patterns: [
                        "(?i)respuestas:\\s*([A-Za-z\\-\\s]+)"
                    ], removeSpaces: true) {
                        recognizedAnswers = answers.uppercased()
                        
                        if let answers = recognizedAnswers, answers.count != template.numberOfQuestions {
                            continuation.resume(returning: .failure(
                                ExamRecognitionError.invalidAnswersCount(
                                    expected: Int(template.numberOfQuestions),
                                    actual: answers.count
                                )
                            ))
                            return
                        }
                    }
                }
                
                if recognizedAnswers == nil || recognizedAnswers?.isEmpty == true {
                    continuation.resume(returning: .failure(ExamRecognitionError.noAnswers))
                    return
                }
                
                if recognizedName == nil {
                    continuation.resume(returning: .failure(ExamRecognitionError.noName))
                    return
                }
                
                if recognizedDNI == nil {
                    continuation.resume(returning: .failure(ExamRecognitionError.noDNI))
                    return
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
    
    private func extractData(from text: String, patterns: [String], removeSpaces: Bool = true) -> String? {
        for pattern in patterns {
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                let range = NSRange(location: 0, length: text.utf16.count)
                if let match = regex.firstMatch(in: text, options: [], range: range) {
                    if let dataRange = Range(match.range(at: 1), in: text) {
                        var result = String(text[dataRange])
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        if removeSpaces {
                            result = result.replacingOccurrences(of: " ", with: "")
                        }
                        return result
                    }
                }
            } catch {
                print("Error creating regex: \(error)")
            }
        }
        return nil
    }
}
