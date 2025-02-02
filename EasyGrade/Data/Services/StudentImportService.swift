//
//  StudentImportService.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//

import Foundation

protocol StudentImportServiceProtocol {
    func importStudentFromCSV(from url: URL) async -> Result<[Student],StudentImportError>
}

import Foundation

final class StudentImportService: StudentImportServiceProtocol {
    func importStudentFromCSV(from url: URL) async -> Result<[Student],StudentImportError> {

        guard url.startAccessingSecurityScopedResource() else {
            return .failure(.fileReadError("No se pudo acceder al archivo CSV. Verifica los permisos."))
        }

        defer { url.stopAccessingSecurityScopedResource() }

        var students: [Student] = []
        
        do {
            let csvContent = try String(contentsOf: url, encoding: .utf8)
            let lines = csvContent.components(separatedBy: "\n").filter { !$0.isEmpty }
            
            guard !lines.isEmpty else {
                return .failure(.emptyFile)
            }
            
            for (index, line) in lines.enumerated() {
                let columns = line.components(separatedBy: "\t")
                
                if index == 0 && columns[0].lowercased().contains("apellidos") {
                    continue
                }

                guard columns.count >= 3 else {
                    return .failure(.invalidFormat)
                }

                let lastName = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let firstName = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let dni = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)

                let student = Student(id: UUID(), dni: dni, name: firstName, lastName: lastName)
                students.append(student)
            }
        } catch let error as NSError {
            return .failure(.fileReadError("Error al leer el archivo CSV: \(error.localizedDescription)"))
        }
        
        return .success(students)
    }
}

enum StudentImportError: Error {
    case emptyFile
    case fileReadError(String)
    case invalidFormat
}
