
import SwiftUI
import CoreImage

struct CameraView: View {
    
    @ObservedObject var viewmodel: CameraViewModel
    
    init(viewmodel: CameraViewModel) {
        self.viewmodel = viewmodel
    }
    
    var body: some View {
        VStack {
            if viewmodel.showLoading {
                ProgressView("Cargando...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                cameraPreview
                    .overlay(
                        VStack {
                            if let errorMessage = viewmodel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            Spacer()
                            captureButton
                                .padding(.vertical)
                        }
                    )
            }
        }
        .onAppear {
            viewmodel.checkCameraPermission()
            viewmodel.startCaptureSession()
        }
        .onDisappear {
            viewmodel.stopCaptureSession()
        }
    }
    
    private var cameraPreview: some View {
        GeometryReader { geometry in
            if let image = viewmodel.image {
                Image(decorative: image, scale: 1.0)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                Color.black
            }
        }
    }
    
    private var captureButton: some View {
        Button(action: {
            Task {
                await viewmodel.takePhoto()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 65, height: 65)
                
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 75, height: 75)
            }
        }
    }
}


