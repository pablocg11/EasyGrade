//
//  ImportStudentListFromCSV.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//

import Foundation

protocol ImportStudentListFromCSVProtocol {
    func execute(_ csvUrl: URL) async -> Result<[Student],StudentImportError>
}

final class ImportStudentListFromCSV: ImportStudentListFromCSVProtocol {
    private let repository: StudentRepositoryProtocol
    
    init(repository: StudentRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ csvUrl: URL) async -> Result<[Student],StudentImportError> {
        return await self.repository.fetchStudentsFromFile(csvUrl)
    }
}
