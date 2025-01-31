import SwiftUI

enum RecognitionState {
    case placeholder
    case notification
    case recognizedData
}

struct RecognitionView: View {
    @State var template: ExamTemplate
    @ObservedObject var examCorrectionViewModel: ExamCorrectionViewModel
    @ObservedObject var cameraViewModel: CameraViewModel
    
    @State private var recognitionState: RecognitionState = .placeholder
    @State private var recognizedData: ExamData?
    @State private var editableAnswers: String = ""

    @State var selectedStudent: Student?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            CameraPreviewView(session: cameraViewModel.session)
                .ignoresSafeArea()
                .onAppear { cameraViewModel.startSession() }
                .onDisappear { cameraViewModel.stopSession() }

            contentBasedOnState()
        }
        .onChange(of: cameraViewModel.examExtractedData) {
            handleDataChange(cameraViewModel.examExtractedData)
        }
        .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    private func contentBasedOnState() -> some View {
        switch recognitionState {
        case .placeholder:
            placeholderView()
        case .notification:
            notificationView()
        case .recognizedData:
            if let data = recognizedData {
                recognizedDataView(data)
            }
        }
    }

    private func placeholderView() -> some View {
        CameraPlaceholderView()
            .transition(.opacity.animation(.easeInOut))
    }

    private func notificationView() -> some View {
        ConfirmationNotification(
            titleNotification: examCorrectionViewModel.errorMessage != nil ? "Error" : "Examen escaneado",
            messageNotification: examCorrectionViewModel.errorMessage != nil ? "El número de respuestas no coincide con el número de preguntas" : "El examen ha sido procesado correctamente",
            error: examCorrectionViewModel.errorMessage != nil ? true : false
        )
        .transition(.scale(scale: 0.9).combined(with: .opacity).animation(.easeInOut))
    }

    private func recognizedDataView(_ data: ExamData) -> some View {
        VStack {
            if examCorrectionViewModel.isLoading {
                MainLoading()
            } else if let examCalification = examCorrectionViewModel.examScore {
                recognizedDataBody(data, examCalification)
            }
        }
        .onAppear {
            examCorrectionViewModel.onAppear(studentName: data.name,
                                             studentDNI: data.dni,
                                             studentAnswers: data.answers,
                                             template: template,
                                             students: template.students)
        }
    }

    private func recognizedDataBody(_ data: ExamData, _ examCalification: ExamCorrectionResult) -> some View {
        ExamCorrectionView(
            extractedData: data,
            matchingStudent: examCorrectionViewModel.matchingStudent,
            saveAction: { saveStudentEvaluation(data, examCalification) },
            template: template,
            examCalification: examCalification,
            selectedStudent: $selectedStudent
        )
        .transition(.opacity.animation(.easeInOut))
    }

    private func handleDataChange(_ newData: ExamData?) {
        guard let data = newData else { return }
        recognizedData = data
        editableAnswers = data.answers

        examCorrectionViewModel.onAppear(studentName: data.name,
                                         studentDNI: data.dni,
                                         studentAnswers: data.answers,
                                         template: template,
                                         students: template.students)

        withAnimation {
            recognitionState = .notification
            cameraViewModel.stopSession()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if examCorrectionViewModel.errorMessage != nil {
                dismiss()
            } else {
                withAnimation {
                    recognitionState = .recognizedData
                }
            }
        }
    }

    private func saveStudentEvaluation(_ evaluatedStudent: ExamData, _ examCalification: ExamCorrectionResult) {
        guard let student = selectedStudent else {
            return
        }

        let studentEvaluated = EvaluatedStudent(
            dni: student.dni,
            name: student.name,
            score: examCalification.totalScore,
            answerMatrix: parseAnswers(evaluatedStudent.answers, template: template)
        )

        examCorrectionViewModel.saveEvaluatedStudent(
            evaluatedStudent: studentEvaluated,
            template: template
        )

        withAnimation {
            selectedStudent = nil
            examCorrectionViewModel.matchingStudent = nil
            recognizedData = nil
            recognitionState = .placeholder
        }
        
        cameraViewModel.startSession()
    }

    private func parseAnswers(_ answers: String, template: ExamTemplate) -> [[Bool]] {
        let options = (0..<template.numberOfAnswersPerQuestion).map { index in
            Character(UnicodeScalar("A".unicodeScalars.first!.value + UInt32(index))!)
        }
        
        return answers.map { char in
            if char == "-" {
                return Array(repeating: false, count: Int(template.numberOfAnswersPerQuestion))
            } else {
                return options.map { $0 == char }
            }
        }
    }
}
