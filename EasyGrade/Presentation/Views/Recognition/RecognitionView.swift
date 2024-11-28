import SwiftUI

struct RecognitionView: View {
    @State private var imageTaken: UIImage?
    @State var template: AnswerTemplate
    @ObservedObject var viewModel: ExamDataRecognitionViewModel
    @ObservedObject var examCorrectionViewModel: ExamCorrectionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var editableStudentName: String = ""
    @State var editableStudentDNI: String = ""
    @State var editableStudentAnswers: String = ""

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
        .onAppear {
            if let student = viewModel.currentlyRecognizedStudent,
               let recognizedAnswers = viewModel.recognizedAnswers {
                editableStudentName = student.name
                editableStudentDNI = student.dni
                editableStudentAnswers = recognizedAnswers
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private func displayContent() -> some View {
        Group {
            if viewModel.isLoading {
                loadingIndicator
            } else {
                recognizedDataBody()
            }
        }
    }

    private var loadingIndicator: some View {
        VStack {
            ProgressView("Procesando...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }
    }

    private func recognizedDataBody() -> some View {
        VStack(spacing: 16) {
            imagePreview
            
            if let student = viewModel.currentlyRecognizedStudent, let recognizedAnswers = viewModel.recognizedAnswers {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        ExamCorrectionView(
                            viewmodel: examCorrectionViewModel,
                            student: student,
                            template: template,
                            studentAnswers: recognizedAnswers
                        )
                        
                        Divider()
                        
                        sectionHeader("Datos del alumno")
                        
                        MainTextField(
                            placeholder: "Nombre",
                            text: .constant(student.name),
                            autoCapitalize: true,
                            autoCorrection: true
                        )
                        
                        MainTextField(
                            placeholder: "DNI",
                            text: .constant(student.dni),
                            autoCapitalize: true,
                            autoCorrection: false
                        )
                        
                        MainTextField(
                            placeholder: "Respuestas",
                            text: .constant(recognizedAnswers),
                            autoCapitalize: false,
                            autoCorrection: false
                        )
                    }
                    .padding()
                }
                
                MainButton(
                    title: "Guardar",
                    action: {
                        let updatedStudent = EvaluatedStudent(
                            id: UUID(),
                            dni: editableStudentDNI,
                            name: editableStudentName,
                            score: examCorrectionViewModel.examScore?.totalScore,
                            answerMatrix: parseAnswers(editableStudentAnswers, template: template)
                        )
                        self.viewModel.saveEvaluatedStudent(with: updatedStudent)
                        dismiss()
                    },
                    disabled: student.name.isEmpty || student.dni.isEmpty
                )
                .padding()
                
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            }
            
            Spacer()
        }
        .navigationTitle(template.name)
    }

    private var imagePreview: some View {
        HStack {
            if let imageTaken = imageTaken {
                Image(uiImage: imageTaken)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(8)
                    .shadow(radius: 4)

                Spacer()
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(Color("AppPrimaryColor"))
            .padding(.vertical, 4)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 10) {
            Text(message)
                .foregroundColor(.red)
                .font(.body)
                .multilineTextAlignment(.center)
            
            MainButton(title: "Reintentar", action: {
                imageTaken = nil
            }, disabled: false)
        }
        .padding()
    }

    private func handleNewImage(_ newImage: UIImage?, _ template: AnswerTemplate) {
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
