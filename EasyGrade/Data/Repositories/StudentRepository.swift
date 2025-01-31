//
//  StudentRepository.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//

import Foundation

protocol StudentRepositoryProtocol {
    func fetchStudentsFromFile(_ csvUrl: URL) async -> Result<[Student],StudentImportError>
    func findMatchingStudent(recognizedName: String, recognizedDNI: String, students: [Student]) async -> Student?
}

final class StudentRepository: StudentRepositoryProtocol {
    private let studentImportService: StudentImportServiceProtocol
    private let studentMatchingService: StudentMatchingServiceProtocol
    
    init(studentImportService: StudentImportServiceProtocol,
         studentMatchingService: StudentMatchingServiceProtocol) {
        self.studentImportService = studentImportService
        self.studentMatchingService = studentMatchingService
    }
    
    func fetchStudentsFromFile(_ csvUrl: URL) async -> Result<[Student],StudentImportError> {
        return await self.studentImportService.importStudentFromCSV(from: csvUrl)
    }
    
    func findMatchingStudent(recognizedName: String, recognizedDNI: String, students: [Student]) async -> Student? {
        return await self.studentMatchingService.findBestMatch(for: recognizedName, recognizedDNI: recognizedDNI, in: students)
    }
}
