
import Foundation
import UIKit
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    typealias UIViewControllerType = UIImagePickerController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        viewController.cameraDevice = .rear
        viewController.cameraOverlayView = .none
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //Not used
    }
    
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(self)
    }
}

extension CameraView {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if image.size.width > image.size.height {
                    self.parent.image = image.resize(to: CGSize(width: 3000, height: 2250))
                } else {
                    self.parent.image = image
                }
                
                picker.dismiss(animated: true, completion: nil)
            } else {
                print("Error: No se pudo obtener la imagen")
            }
        }
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
