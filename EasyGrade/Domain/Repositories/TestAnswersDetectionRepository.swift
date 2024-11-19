import Foundation
import Vision
import CoreGraphics
import CoreImage

protocol TestAnswersDetectionRepositoryProtocol {
    func detectAnswers(
        from image: CGImage,
        numberOfQuestions: Int,
        numberOfAnswers: Int,
        brightnessThreshold: Int
    ) async throws -> [[Bool]]
}

class TestAnswerDetectionRepository: TestAnswersDetectionRepositoryProtocol {
    func detectAnswers(
        from image: CGImage,
        numberOfQuestions: Int = 10,
        numberOfAnswers: Int = 4,
        brightnessThreshold: Int = 128
    ) async throws -> [[Bool]] {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNDetectRectanglesRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let rectangles = request.results as? [VNRectangleObservation],
                      let grid = self.getLargestRectangle(rectangles) else {
                    continuation.resume(throwing: NSError(
                        domain: "VisionError",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "No valid rectangles found"]
                    ))
                    return
                }

                let answers = self.processGrid(
                    grid,
                    in: image,
                    numberOfQuestions: numberOfQuestions,
                    numberOfAnswers: numberOfAnswers,
                    brightnessThreshold: brightnessThreshold
                )
                continuation.resume(returning: answers)
            }

            // Configuración del detector de rectángulos
            request.minimumAspectRatio = 0.8  // Ajustar para casilleros más alargados
            request.maximumAspectRatio = 1.5 // Ajustar para casilleros más anchos
            request.minimumSize = 0.05       // Detectar rectángulos más pequeños
            request.maximumObservations = 5  // Permitir más de un rectángulo

            let handler = VNImageRequestHandler(cgImage: image, options: [:])

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func getLargestRectangle(_ rectangles: [VNRectangleObservation]) -> VNRectangleObservation? {
        return rectangles.max(by: { $0.boundingBox.width * $0.boundingBox.height < $1.boundingBox.width * $1.boundingBox.height })
    }

    private func processGrid(
        _ grid: VNRectangleObservation,
        in image: CGImage,
        numberOfQuestions: Int,
        numberOfAnswers: Int,
        brightnessThreshold: Int
    ) -> [[Bool]] {
        // Transformar el rectángulo detectado en coordenadas de píxeles
        let gridBoundingBox = grid.boundingBox
        let imageWidth = CGFloat(image.width)
        let imageHeight = CGFloat(image.height)

        let gridRect = CGRect(
            x: gridBoundingBox.origin.x * imageWidth,
            y: (1 - gridBoundingBox.origin.y - gridBoundingBox.height) * imageHeight,
            width: gridBoundingBox.width * imageWidth,
            height: gridBoundingBox.height * imageHeight
        )

        // Dividir el casillero en filas y columnas
        let rowHeight = gridRect.height / CGFloat(numberOfQuestions)
        let colWidth = gridRect.width / CGFloat(numberOfAnswers)

        var answersMatrix: [[Bool]] = []

        for questionIndex in 0..<numberOfQuestions {
            var answersRow: [Bool] = []
            for answerIndex in 0..<numberOfAnswers {
                let cellRect = CGRect(
                    x: gridRect.origin.x + CGFloat(answerIndex) * colWidth,
                    y: gridRect.origin.y + CGFloat(questionIndex) * rowHeight,
                    width: colWidth,
                    height: rowHeight
                )

                let isMarked = isCellMarked(in: cellRect, image: image, threshold: brightnessThreshold)
                answersRow.append(isMarked)
            }
            answersMatrix.append(answersRow)
        }

        return answersMatrix
    }

    private func isCellMarked(in rect: CGRect, image: CGImage, threshold: Int) -> Bool {
        // Corta la región de la imagen correspondiente a la casilla
        guard let croppedImage = image.cropping(to: rect) else {
            return false
        }

        // Analiza los píxeles de la celda para determinar si está marcada
        let ciImage = CIImage(cgImage: croppedImage)
        let context = CIContext()
        guard let pixelData = context.createCGImage(ciImage, from: ciImage.extent)?.dataProvider?.data else {
            return false
        }

        let data = CFDataGetBytePtr(pixelData)
        let length = CFDataGetLength(pixelData)
        var totalBrightness: Int = 0

        for i in stride(from: 0, to: length, by: 4) {
            // Suma los valores de brillo de los píxeles (R, G, B)
            let r = Int(data![i])
            let g = Int(data![i + 1])
            let b = Int(data![i + 2])
            totalBrightness += (r + g + b) / 3
        }

        let averageBrightness = totalBrightness / (length / 4)

        // Considera la casilla marcada si su brillo promedio es bajo (oscura)
        return averageBrightness < threshold
    }
}
