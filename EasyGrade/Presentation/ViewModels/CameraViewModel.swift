import AVFoundation
import Vision

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var examExtractedData: ExamData?
    @Published var rawExamText: String?

    var session = AVCaptureSession()
    private let textRequest = VNRecognizeTextRequest()
    private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")
    private var isProcessing = false

    private let recognizeExamDataUseCase: RecognizeExamDataUseCaseProtocol

    init(recognizeExamDataUseCase: RecognizeExamDataUseCaseProtocol) {
        self.recognizeExamDataUseCase = recognizeExamDataUseCase
        super.init()
        configureCamera()
        configureVision()
    }

    func startSession() {
        sessionQueue.async { [weak self] in
            self?.session.startRunning()
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }

    private func configureCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)

            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            session.addOutput(videoOutput)
        } catch {
            print("Error configuring camera: \(error.localizedDescription)")
        }
    }

    private func configureVision() {
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = true
        textRequest.recognitionLanguages = ["es"]
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard !isProcessing else { return }
        isProcessing = true

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            isProcessing = false
            return
        }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try requestHandler.perform([textRequest])
            if let observations = textRequest.results {
                let rawText = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")

                try processExamData(rawText)
            }
        } catch {
            print("Error processing text: \(error.localizedDescription)")
            isProcessing = false
        }
    }

    private func processExamData(_ rawText: String) throws {
        if let extractedData = try recognizeExamDataUseCase.execute(rawText) {
            DispatchQueue.main.async {
                self.examExtractedData = extractedData
                self.rawExamText = rawText
            }
        }

        DispatchQueue.main.async {
            self.isProcessing = false
        }
    }
}
