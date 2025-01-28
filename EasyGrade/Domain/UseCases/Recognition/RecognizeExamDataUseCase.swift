
import Foundation
import Vision

protocol RecognizeExamDataUseCaseProtocol {
    func execute(_ rawText: String) throws -> ExamData?
}

class RecognizeExamDataUseCase: RecognizeExamDataUseCaseProtocol {
    private let service: ExamDataProcessingServiceProtocol
    
    init(service: ExamDataProcessingServiceProtocol) {
        self.service = service
    }

    func execute(_ rawText: String) throws -> ExamData? {
        return try self.service.processExamData(rawText)
    }
}

