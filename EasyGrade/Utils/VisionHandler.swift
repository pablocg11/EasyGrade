
import Foundation
import Combine
import UIKit
import Vision

class VisionHandler: ObservableObject {
    
    func detectRectangles(in image: CGImage) -> AnyPublisher<[VNRectangleObservation], Error> {
        return Future { promise in
            let request = VNDetectRectanglesRequest { request, error in
                if let error = error {
                    promise(.failure(error))
                } else if let observations = request.results as? [VNRectangleObservation] {
                    promise(.success(observations))
                } else {
                    promise(.failure(NSError(domain: "VisionError", code: -1, userInfo: nil)))
                }
            }

            // Configuraciones opcionales del request
            request.minimumAspectRatio = 0.3
            request.maximumAspectRatio = 1.0
            request.minimumSize = 0.1
            request.quadratureTolerance = 45.0

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            do {
                try handler.perform([request])
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func detectMarks(in rectangles: [VNRectangleObservation], image: CGImage) -> AnyPublisher<[Bool], Error> {
        return Future { promise in
            var results: [Bool] = []
            let ciImage = CIImage(cgImage: image)
            
            for rect in rectangles {
                // Convertir boundingBox a CGRect
                let boundingBox = CGRect(x: rect.boundingBox.origin.x * CGFloat(ciImage.extent.width),
                                          y: rect.boundingBox.origin.y * CGFloat(ciImage.extent.height),
                                          width: rect.boundingBox.size.width * CGFloat(ciImage.extent.width),
                                          height: rect.boundingBox.size.height * CGFloat(ciImage.extent.height))

                // Extraemos la región del rectángulo
                let rectRegion = ciImage.cropped(to: boundingBox)

                // Aquí puedes implementar la lógica para detectar marcas (ej. "X")
                let markDetected = self.detectMarkInRegion(image: rectRegion)
                results.append(markDetected)
            }
            promise(.success(results))
        }
        .eraseToAnyPublisher()
    }

    private func detectMarkInRegion(image: CIImage) -> Bool {
        // Aquí puedes realizar el análisis para detectar una "X" u otra marca.
        // Por simplicidad, retornamos un valor aleatorio.
        return Bool.random()  // Debes implementar tu lógica aquí.
    }
}
