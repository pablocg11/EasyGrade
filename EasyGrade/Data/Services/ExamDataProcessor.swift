//
//  ExamTemplateProcessor.swift
//  EasyGrade
//
//  Created by Pablo Castro on 10/1/25.
//

import Foundation

protocol ExamDataProcessorProtocol {
    func processExamData(_ rawText: String) throws -> ExamData?
}

final class ExamDataProcessor: ExamDataProcessorProtocol {
    func processExamData(_ rawText: String) throws -> ExamData? {
        let lines = rawText.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        guard let name = self.extractData(from: lines, patterns: [
            #"(?i)^nombre y apellidos:\s*(.+)$"#
        ], removeSpaces: false)?.uppercased() else {
            throw ExamDataProcessingError.missingField("Nombre y Apellidos")
        }

        guard let dni = self.extractData(from: lines, patterns: [
            #"(?i)^dni:\s*([0-9A-Z]+)$"#
        ], removeSpaces: true)?.uppercased() else {
            throw ExamDataProcessingError.missingField("DNI")
        }

        guard let answers = self.extractData(from: lines, patterns: [
            #"(?i)^respuestas:\s*([A-Z\s\-]+)$"#
        ], removeSpaces: true)?.uppercased() else {
            throw ExamDataProcessingError.missingField("Respuestas")
        }

        return ExamData(name: name, dni: dni, answers: answers)
    }
    
    private func extractData(from lines: [String], patterns: [String], removeSpaces: Bool) -> String? {
        for line in lines {
            for pattern in patterns {
                if let match = self.matchRegex(line, pattern: pattern) {
                    return removeSpaces
                        ? match.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
                        : match
                }
            }
        }
        return nil
    }
    
    private func matchRegex(_ text: String, pattern: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range),
               let matchedRange = Range(match.range(at: 1), in: text) {
                return String(text[matchedRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            print("Error creando regex: \(error.localizedDescription)")
        }
        return nil
    }
}
