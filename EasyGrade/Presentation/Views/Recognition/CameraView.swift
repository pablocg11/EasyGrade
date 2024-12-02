import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onDismiss: (() -> Void)?
    
    class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
        var imageCaptured: ((UIImage?) -> Void)?
        var onDismiss: (() -> Void)?
        let captureSession = AVCaptureSession()
        let photoOutput = AVCapturePhotoOutput()
        var previewLayer: AVCaptureVideoPreviewLayer!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            captureSession.sessionPreset = .photo
            guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: backCamera) else {
                print("Error al configurar la cámara")
                return
            }
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspect
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
            
            addCaptureButton()
            addBackButton()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            adjustPreviewLayerFrame()
        }
        
        func adjustPreviewLayerFrame() {
            guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                return
            }
            
            let activeFormat = backCamera.activeFormat
            let dimensions = CMVideoFormatDescriptionGetDimensions(activeFormat.formatDescription)
            let videoAspectRatio = CGFloat(dimensions.width) / CGFloat(dimensions.height)
            let screenAspectRatio = view.bounds.width / view.bounds.height
            
            if videoAspectRatio > screenAspectRatio {
                // Ajusta el ancho para que coincida con la relación de aspecto del video
                let adjustedWidth = view.bounds.height * videoAspectRatio
                previewLayer.frame = CGRect(
                    x: (view.bounds.width - adjustedWidth) / 2,
                    y: 0,
                    width: adjustedWidth,
                    height: view.bounds.height
                )
            } else {
                // Ajusta la altura para que coincida con la relación de aspecto del video
                let adjustedHeight = view.bounds.width / videoAspectRatio
                previewLayer.frame = CGRect(
                    x: 0,
                    y: (view.bounds.height - adjustedHeight) / 2,
                    width: view.bounds.width,
                    height: adjustedHeight
                )
            }
        }
        
        func addCaptureButton() {
            let captureButton = UIButton(type: .system)
            captureButton.translatesAutoresizingMaskIntoConstraints = false
            captureButton.backgroundColor = .white
            captureButton.layer.cornerRadius = 40
            captureButton.layer.borderWidth = 4
            captureButton.layer.borderColor = UIColor.gray.cgColor
            captureButton.clipsToBounds = true
            captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
            
            view.addSubview(captureButton)
            
            NSLayoutConstraint.activate([
                captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                captureButton.widthAnchor.constraint(equalToConstant: 80),
                captureButton.heightAnchor.constraint(equalToConstant: 80)
            ])
        }
        
        func addBackButton() {
            let backButton = UIButton(type: .system)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.setTitle("Volver", for: .normal)
            backButton.setTitleColor(.white, for: .normal)
            backButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            backButton.layer.cornerRadius = 15
            backButton.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
            
            view.addSubview(backButton)
            
            NSLayoutConstraint.activate([
                backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                backButton.widthAnchor.constraint(equalToConstant: 80),
                backButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        @objc func closeCamera() {
            onDismiss?()
        }
        
        @objc func capturePhoto() {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                print("Error al capturar foto: \(error)")
                imageCaptured?(nil)
                return
            }
            
            if let data = photo.fileDataRepresentation(),
               let image = UIImage(data: data) {
                imageCaptured?(image)
            } else {
                imageCaptured?(nil)
            }
        }
    }
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.imageCaptured = { image in
            self.image = image
        }
        controller.onDismiss = self.onDismiss
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
