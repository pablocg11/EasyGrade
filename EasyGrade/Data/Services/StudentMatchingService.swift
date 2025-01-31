//
//  StudentMatchingService.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//

import Foundation

protocol StudentMatchingServiceProtocol {
    func findBestMatch(for recognizedName: String, recognizedDNI: String, in students: [Student]) async -> Student?
}

final class StudentMatchingService: StudentMatchingServiceProtocol {
    func findBestMatch(for recognizedName: String, recognizedDNI: String, in students: [Student]) async -> Student? {
        guard !students.isEmpty else {
            return nil
        }
        
        let recognizedDNINumbers = extractDNINumbers(from: recognizedDNI)

        if let exactMatch = students.first(where: { $0.dni.uppercased() == recognizedDNI.uppercased() }) {
            return exactMatch
        }
        
        if let dniMatch = students.first(where: { extractDNINumbers(from: $0.dni) == recognizedDNINumbers }) {
            return dniMatch
        }
        
        var bestMatch: Student?
        var bestScore = Int.max

        for student in students {
            let distance = levenshteinDistance(recognizedName.uppercased(), student.name.uppercased())
            let maxAllowedDistance = max(1, student.name.count / 5)

            if distance <= maxAllowedDistance, distance < bestScore {
                bestScore = distance
                bestMatch = student
            }
        }
        
        if let bestMatch = bestMatch {
            return bestMatch
        }
        
        return nil
    }
    
    private func extractDNINumbers(from dni: String) -> String {
        return dni.trimmingCharacters(in: .whitespaces)
            .uppercased()
            .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }

    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let s1Count = s1.count
        let s2Count = s2.count
        var matrix = Array(repeating: Array(repeating: 0, count: s2Count + 1), count: s1Count + 1)

        for i in 0...s1Count { matrix[i][0] = i }
        for j in 0...s2Count { matrix[0][j] = j }

        for (i, char1) in s1.enumerated() {
            for (j, char2) in s2.enumerated() {
                let cost = (char1 == char2) ? 0 : 1
                matrix[i + 1][j + 1] = min(
                    matrix[i][j + 1] + 1,
                    matrix[i + 1][j] + 1,
                    matrix[i][j] + cost   
                )
            }
        }
        return matrix[s1Count][s2Count]
    }
}
