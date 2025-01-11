import SwiftUI

enum RecognitionState {
    case placeholder
    case notification
    case recognizedData
}

struct RecognitionView: View {
    @State var template: AnswerTemplate
    @ObservedObject var examCorrectionViewModel: ExamCorrectionViewModel
    @ObservedObject var cameraViewModel: CameraViewModel

    @State private var recognitionState: RecognitionState = .placeholder
    @State private var recognizedData: ExamData?
    
    @State private var editableStudentName = ""
    @State private var editableStudentDNI = ""

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
        ConfirmationNotification()
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
            examCorrectionViewModel.onAppear(studentAnswers: data.answers, template: template)
        }
    }

    private func recognizedDataBody(_ data: ExamData, _ examCalification: ExamCorrectionResult) -> some View {
        ExamCorrectionView(
            extractedData: data,
            saveAction: { saveStudentEvaluation(data, examCalification) },
            template: template,
            examCalification: examCalification,
            editableStudentName: $editableStudentName,
            editableStudentDNI: $editableStudentDNI
        )
        .transition(.opacity.animation(.easeInOut))
    }

    private func handleDataChange(_ newData: ExamData?) {
        guard let data = newData else { return }
        recognizedData = data

        withAnimation {
            recognitionState = .notification
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                recognitionState = .recognizedData
                cameraViewModel.stopSession()
            }
        }
    }

    private func saveStudentEvaluation(_ evaluatedStudent: ExamData, _ examCalification: ExamCorrectionResult) {
        let studentEvaluated = EvaluatedStudent(
            dni: editableStudentDNI,
            name: editableStudentName,
            score: examCalification.totalScore,
            answerMatrix: parseAnswers(evaluatedStudent.answers, template: template)
        )

        examCorrectionViewModel.saveEvaluatedStudent(
            evaluatedStudent: studentEvaluated,
            template: template
        )
    }

    private func parseAnswers(_ answers: String, template: AnswerTemplate) -> [[Bool]] {
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
