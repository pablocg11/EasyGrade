
import Foundation
import CoreGraphics

class StudentRecognitionViewModel: ObservableObject {
    private let recognizeTextUseCase: RecognizeTextUseCase
    private let fetchEvaluatedStudents: FetchEvaluatedStudentsUseCase
    private let saveStudentUseCase: SaveEvaluatedStudentUseCase
    private let testAnswersDetectionUseCase: DetectTestAnswersUseCase

    @Published var recognizedStudents: [EvaluatedStudent] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var currentlyRecognizedStudent: EvaluatedStudent?

    init(
        recognizeTextUseCase: RecognizeTextUseCase,
        fetchEvaluateStudents: FetchEvaluatedStudentsUseCase,
        saveStudentUseCase: SaveEvaluatedStudentUseCase,
        testAnswersDetectionUseCase: DetectTestAnswersUseCase
    ) {
        self.recognizeTextUseCase = recognizeTextUseCase
        self.fetchEvaluatedStudents = fetchEvaluateStudents
        self.saveStudentUseCase = saveStudentUseCase
        self.testAnswersDetectionUseCase = testAnswersDetectionUseCase
    }

    @MainActor
    func processCapturedImage(cgImage: CGImage) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let (name, dni) = try await recognizeTextUseCase.execute(image: cgImage)

            guard let recognizedName = name, !recognizedName.isEmpty else {
                isLoading = false
                return false
            }
            
            do {
                let answers = try await testAnswersDetectionUseCase.execute(
                    image: cgImage,
                    numberOfQuestions: 10,
                    numberOfAnswers: 4,
                    brightnessThreshold: 128
                )
                print(answers)
            } catch {
                errorMessage = "Error al detectar el casillero: \(error.localizedDescription)"
                print(errorMessage)
            }

            let student = EvaluatedStudent(
                id: UUID(),
                dni: dni,
                name: recognizedName,
                answerMatrix: nil,
                templateId: nil
            )

            currentlyRecognizedStudent = student
            isLoading = false
            return true
        } catch {
            errorMessage = "Error al procesar la imagen: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }
    
    func saveConfirmedStudent(_ student: EvaluatedStudent) {
        recognizedStudents.append(student)
    }
}
