import SwiftUI

struct CreateAnswerTemplateView: View {
    
    @ObservedObject var viewModel: CreateAnswerTemplateViewModel
    
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
    
    private var isTemplateValid: Bool {
        return templateName.isEmpty || correctAnswerScore <= 0 || wrongAnswerPenalty < 0 || blankAnswerPenalty < 0
    }
    
    private var hasValidCorrectAnswers: Bool {
        correctAnswerMatrix.allSatisfy { $0.contains(true) }
    }
    
    var body: some View {
        NavigationStack {
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
                
                MainButton(title: "Guardar", action: saveTemplate, disabled: isTemplateValid || !hasValidCorrectAnswers)
            }
            .padding()
            .onChange(of: numberOfQuestions) { adjustFields() }
            .onChange(of: numberOfAnswers) { adjustFields() }
        }
    }
}

private extension CreateAnswerTemplateView {
    
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
                                                           numberOfAnswers: $numberOfAnswers,
                                                           moreThanOneAnswer: $moreThanOneAnswer)) {
                NavigationButton(navigationTitle: "Respuestas correctas")
            }
        }
    }
    
    func saveTemplate() {
        viewModel.createAnswerTemplate(
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
