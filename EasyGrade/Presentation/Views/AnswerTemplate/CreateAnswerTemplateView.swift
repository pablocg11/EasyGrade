import SwiftUI

struct CreateExamTemplateView: View {
    
    @ObservedObject var viewModel: CreateExamTemplateViewModel
    
    @State private var templateName: String = ""
    @State private var selectedDate: Date = Date()
    @State private var numberOfQuestions: Int16 = 10
    @State private var numberOfAnswers: Int16 = 4
    @State private var moreThanOneAnswer: Bool = false
    @State private var correctAnswerScore: Double = 0.0
    @State private var wrongAnswerPenalty: Double = 0.0
    @State private var blankAnswerPenalty: Double = 0.0
    
    @State private var cancelledQuestions: [Bool] = Array(repeating: false, count: 10)
    @State private var correctAnswerMatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: 4), count: 10)
    
    @State private var showDocumentPicker = false
    @State private var showStudentImportNotification: Bool = false
    @State private var showTemplateCreationNotification: Bool = false
    
    private var isTemplateValid: Bool {
        return templateName.isEmpty || correctAnswerScore <= 0 || wrongAnswerPenalty <= 0 || blankAnswerPenalty < 0
    }
    
    private var hasValidCorrectAnswers: Bool {
        correctAnswerMatrix.allSatisfy { $0.contains(true) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    MainText(text: "Crear plantilla",
                             textColor: Color("AppPrimaryColor"),
                             font: .title2)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                            templateInfoSection
                            configurationSection
                            navigationLinks
                        }
                    }
                    
                    VStack(spacing: 10){
                        MainButton(title: "Importar alumnos") {
                            showDocumentPicker = true
                        }
                        
                        MainButton(title: "Guardar", action: {
                            saveTemplate()
                            showTemplateCreationNotification = true
                        }
                                   ,disabled: isTemplateValid || !hasValidCorrectAnswers)
                    }
                }
                .padding()
                .onChange(of: numberOfQuestions) { adjustFields() }
                .onChange(of: numberOfAnswers) { adjustFields() }
                .onChange(of: viewModel.studentsImported) {
                    if let students = viewModel.studentsImported, !students.isEmpty {
                        showStudentImportNotification = true
                    }
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker { url in
                        Task {
                            await viewModel.importStudents(from: url)
                        }
                    }
                }
                
                if showTemplateCreationNotification {
                    templateCreationNotificationView()
                        .zIndex(1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    showTemplateCreationNotification = false
                                }
                            }
                        }
                }
                
                if showStudentImportNotification {
                    studentListImportedNotification()
                        .zIndex(1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    showStudentImportNotification = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    private func templateCreationNotificationView() -> some View {
        ConfirmationNotification(titleNotification: "Plantilla de examen creada", messageNotification: "La plantilla de examen ha sido creada correctamente", error: false)
            .transition(.scale(scale: 0.9).combined(with: .opacity).animation(.easeInOut))
    }
    
    private func studentListImportedNotification() -> some View {
        ConfirmationNotification(
            titleNotification: "Alumnos importados",
            messageNotification: "Se han importado \(viewModel.studentsImported?.count ?? 0) alumnos correctamente.",
            error: false
        )
        .transition(.scale(scale: 0.9).combined(with: .opacity).animation(.easeInOut))
    }
}

private extension CreateExamTemplateView {
    
    var templateInfoSection: some View {
        Group {
            MainTextField(placeholder: "Nombre de la plantilla",
                          text: $templateName,
                          autoCapitalize: false,
                          autoCorrection: false)
            
            MainDatePicker(selectedDate: $selectedDate)
        }
    }
    
    var configurationSection: some View {
        Group {
            MainNumberPicker(placeholder: "Número de preguntas",
                             minValue: 1,
                             maxValue: 100,
                             selectedValue: Binding(
                                get: { numberOfQuestions },
                                set: {
                                    numberOfQuestions = Int16($0)
                                    adjustFields()
                                }
                             ))
            
            MainNumberPicker(placeholder: "Número de respuestas",
                             minValue: 2,
                             maxValue: 8,
                             selectedValue: Binding(
                                get: { numberOfAnswers },
                                set: {
                                    numberOfAnswers = Int16($0)
                                    adjustFields()
                                }
                             ))
            
            MainNumberTextField(placeholder: "Puntuación por respuesta correcta",
                                number: $correctAnswerScore)
            
            MainNumberTextField(placeholder: "Penalización por respuesta incorrecta",
                                number: $wrongAnswerPenalty)
            
            MainNumberTextField(placeholder: "Penalización por respuesta en blanco",
                                number: $blankAnswerPenalty)
        }
    }
    
    var navigationLinks: some View {
        Group {
            NavigationLink(destination: CancelledQuestionsView(cancelledQuestions: $cancelledQuestions,
                                                               numberOfQuestions: $numberOfQuestions)) {
                NavigationButton(navigationTitle: "Preguntas anuladas")
            }
            
            NavigationLink(destination: CorrectAnswersView(correctAnswerMatrix: $correctAnswerMatrix,
                                                           numberOfQuestions: $numberOfQuestions,
                                                           numberOfAnswers: $numberOfAnswers)) {
                NavigationButton(navigationTitle: "Respuestas correctas")
            }
        }
    }
    
    func saveTemplate() {
        viewModel.createExamTemplate(
            name: templateName,
            date: selectedDate,
            numberOfQuestions: numberOfQuestions,
            numberOfAnswersPerQuestion: numberOfAnswers,
            multipleCorrectAnswers: moreThanOneAnswer,
            scoreCorrectAnswer: correctAnswerScore,
            penaltyIncorrectAnswer: wrongAnswerPenalty,
            penaltyBlankAnswer: blankAnswerPenalty,
            cancelledQuestions: cancelledQuestions,
            correctAnswerMatrix: correctAnswerMatrix
        )
        resetFields()
    }
    
    func adjustFields() {
        cancelledQuestions = Array(repeating: false, count: Int(numberOfQuestions))
        correctAnswerMatrix = Array(repeating: Array(repeating: false, count: Int(numberOfAnswers)), count: Int(numberOfQuestions))
    }
    
    func resetFields() {
        templateName = ""
        selectedDate = Date()
        numberOfQuestions = 10
        numberOfAnswers = 4
        moreThanOneAnswer = false
        correctAnswerScore = 0.0
        wrongAnswerPenalty = 0.0
        blankAnswerPenalty = 0.0
        adjustFields()
    }
}
