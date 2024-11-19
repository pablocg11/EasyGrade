
import SwiftUI

struct ContentView: View {
    @State private var imageTaken: UIImage?
    @State private var editingStudent: EvaluatedStudent?
    @ObservedObject var viewModel: StudentRecognitionViewModel

    var body: some View {
        VStack {
            if imageTaken == nil {
                CameraView(image: $imageTaken)
                    .ignoresSafeArea()
            } else {
                if viewModel.isLoading {
                    ProgressView("Procesando...")
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    VStack {
                        if let imageTaken = imageTaken {
                            Image(uiImage: imageTaken)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .padding()
                        }

                        if let student = editingStudent {
                            StudentEditableCard(
                                student: $editingStudent,
                                onConfirm: {
                                    if let confirmedStudent = editingStudent {
                                        viewModel.saveConfirmedStudent(confirmedStudent)
                                        editingStudent = nil
                                        imageTaken = nil // Reinicia la captura
                                    }
                                }
                            )
                        } else {
                            // Lista de estudiantes guardados
                            List(viewModel.recognizedStudents, id: \.id) { student in
                                VStack(alignment: .leading) {
                                    Text(student.name)
                                        .font(.headline)
                                    if let dni = student.dni {
                                        Text("DNI: \(dni)")
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())

                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }

                            Button("Volver a tomar la foto") {
                                imageTaken = nil
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onChange(of: imageTaken) {
            if let newImage = imageTaken {
                Task {
                    if let cgImage = newImage.cgImage {
                        let success = await viewModel.processCapturedImage(cgImage: cgImage)
                        if success {
                            editingStudent = viewModel.currentlyRecognizedStudent
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                }
            }
        }
        .alert("No se pudo reconocer el nombre", isPresented: $viewModel.showAlert) {
            Button("Volver a intentar", role: .cancel) {
                imageTaken = nil
            }
        } message: {
            Text("Por favor, toma otra foto e intenta nuevamente.")
        }
    }
}
