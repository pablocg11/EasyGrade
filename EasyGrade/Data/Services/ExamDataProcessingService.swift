import Foundation

protocol ExamDataProcessingServiceProtocol {
    func processExamData(_ rawText: String) throws -> ExamData?
}

final class ExamDataProcessingService: ExamDataProcessingServiceProtocol {
    func processExamData(_ rawText: String) throws -> ExamData? {
        let lines = rawText.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        guard let name = extractData(from: lines, pattern: RegexPatterns.nameRegex)?
            .replacingOccurrences(of: "[\\,.]", with: "", options: .regularExpression)
            .uppercased() else {
            throw ExamDataProcessingError.missingField("name_surname")
        }
                        
        guard let dni = extractData(from: lines, pattern: RegexPatterns.dniRegex)?
            .replacingOccurrences(of: "[\\s\\-\\.]", with: "", options: .regularExpression)
            .uppercased() else {
            throw ExamDataProcessingError.missingField("dni")
        }
                        
        guard let answers = extractData(from: lines, pattern: RegexPatterns.answersRegex)?
                .replacingOccurrences(of: "\\s", with: "", options: .regularExpression).uppercased() else {
            throw ExamDataProcessingError.missingField("answers")
        }
                
        return ExamData(name: name, dni: dni, answers: answers)
    }
    
    private func extractData(from lines: [String], pattern: String) -> String? {
        for (index, line) in lines.enumerated() {
            if let match = matchRegex(line, pattern: pattern) {
                return match
            }
            if index < lines.count - 1 {
                let combinedLine = "\(line) \(lines[index + 1])"
                if let combinedMatch = matchRegex(combinedLine, pattern: pattern) {
                    return combinedMatch
                }
            }
        }
        return nil
    }
    
    private func matchRegex(_ text: String, pattern: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = regex.firstMatch(in: text, options: [], range: range),
              let matchedRange = Range(match.range(at: 1), in: text) else { return nil }
        return String(text[matchedRange]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
