//
//  MatchStudentUseCase.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//

import Foundation

protocol MatchStudentUseCaseProtocol {
    func execute(recognizedName: String, recognizedDNI: String, students: [Student]) async -> Student?
}

final class MatchStudentUseCase: MatchStudentUseCaseProtocol {
    private let studentMatchingService: StudentMatchingServiceProtocol

    init(studentMatchingService: StudentMatchingServiceProtocol) {
        self.studentMatchingService = studentMatchingService
    }

    func execute(recognizedName: String, recognizedDNI: String, students: [Student]) async -> Student? {
        return await studentMatchingService.findBestMatch(for: recognizedName, recognizedDNI: recognizedDNI, in: students)
    }
}
