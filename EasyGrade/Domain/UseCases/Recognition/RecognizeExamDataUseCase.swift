
import Foundation
import Vision

protocol RecognizeExamDataUseCaseProtocol {
    func execute(_ rawText: String) throws -> ExamData?
}

class RecognizeExamDataUseCase: RecognizeExamDataUseCaseProtocol {
    private let processor: ExamDataProcessorProtocol
    
    init(processor: ExamDataProcessorProtocol) {
        self.processor = processor
    }

    func execute(_ rawText: String) throws -> ExamData? {
        return try self.processor.processExamData(rawText)
    }
}

