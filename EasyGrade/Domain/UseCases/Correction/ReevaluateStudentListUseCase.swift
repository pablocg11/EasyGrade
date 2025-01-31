//
//  Re-evaluateStudentListUseCase.swift
//  EasyGrade
//
//  Created by Pablo Castro on 31/1/25.
//

import Foundation

protocol ReevaluateStudentListUseCaseProtocol {
    func execute(evaluatedStudentList: [EvaluatedStudent], template: ExamTemplate) async throws -> [EvaluatedStudent]
}

final class ReevaluateStudentListUseCase: ReevaluateStudentListUseCaseProtocol {
    private let service: ExamCorrectionServiceProtocol
    
    init(service: ExamCorrectionServiceProtocol) {
        self.service = service
    }
    
    func execute(evaluatedStudentList: [EvaluatedStudent], template: ExamTemplate) async throws -> [EvaluatedStudent] {
        try await self.service.reEvaluateStudentList(students: evaluatedStudentList, template: template)
    }
}
