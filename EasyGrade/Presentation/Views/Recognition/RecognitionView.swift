
import SwiftUI

struct RecognitionView: View {
    @State private var imageTaken: UIImage?
    @State var template: AnswerTemplate
    @ObservedObject var viewModel: ExamDataRecognitionViewModel
    @State private var navigateToCorrection: Bool = false

    var body: some View {
        VStack {
            if imageTaken == nil {
                CameraView(image: $imageTaken)
                    .ignoresSafeArea()
            } else {
                displayContent()
            }
        }
        .onChange(of: imageTaken) {
            handleNewImage(imageTaken, template)
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private func displayContent() -> some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Procesando...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                recognizedDataBody()
            }
        }
    }

    private func recognizedDataBody() -> some View {
        VStack(spacing: 20) {
            HStack {
                if let imageTaken = imageTaken {
                    Image(uiImage: imageTaken)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding([.leading, .top])
                    
                    Spacer()
                }
            }
            
            if let student = viewModel.currentlyRecognizedStudent, let recognizedAnswers = viewModel.recognizedAnswers {
                VStack(alignment: .leading, spacing: 10) {
                    MainTextField(
                        placeholder: "Nombre del alumno",
                        text: .constant(student.name),
                        autoCapitalize: true,
                        autoCorrection: true
                    )
                    
                    MainTextField(
                        placeholder: "DNI del alumno",
                        text: .constant(student.dni),
                        autoCapitalize: true,
                        autoCorrection: false
                    )
                    
                    MainTextField(
                        placeholder: "Respuestas del alumno",
                        text: .constant(recognizedAnswers),
                        autoCapitalize: false,
                        autoCorrection: false
                    )
                    
                    NavigationLink(
                        destination: ExamCorrectionFactory().createView(
                            student: student,
                            template: template,
                            studentAnswers: recognizedAnswers
                        ),
                        isActive: $navigateToCorrection
                    ) {
                        EmptyView()
                    }
                    
                    MainButton(
                        title: "Corregir",
                        action: {
                            navigateToCorrection = true
                        },
                        disabled: student.name.isEmpty || student.dni.isEmpty
                    )
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                
                MainButton(title: "Rehacer foto",
                           action: {
                    imageTaken = nil
                    
                }, disabled: false)
            }
            
            Spacer()
        }
        .navigationTitle(template.name)
    }

    private func handleNewImage(_ newImage: UIImage?,_ template: AnswerTemplate) {
        if let newImage = newImage {
            Task {
                if let cgImage = newImage.cgImage {
                    viewModel.recognizeExamData(with: cgImage, template: self.template)
                } else {
                    viewModel.errorMessage = "Error: No se pudo procesar la imagen."
                }
            }
        }
    }
}
