import SwiftUI

struct CreateAnswerTemplateView: View {
    
    @ObservedObject var viewModel: CreateAnswerTemplateViewModel
    
    init(viewModel: CreateAnswerTemplateViewModel) {
        self.viewModel = viewModel
    }

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
        return templateName.isEmpty || correctAnswerScore == 0 || wrongAnswerPenalty == 0
    }
    
    private func initFields() {
        templateName = ""
        selectedDate = Date()
        numberOfQuestions = 10
        numberOfAnswers = 4
        moreThanOneAnswer = false
        correctAnswerScore = 0.0
        wrongAnswerPenalty = 0.0
        blankAnswerPenalty = 0.0
        cancelledQuestions = Array(repeating: false, count: 10)
        correctAnswerMatrix = Array(repeating: Array(repeating: false, count: 4), count: 10)
    }
    
    private func adjustCancelledQuestions() {
        if cancelledQuestions.count != Int(numberOfQuestions) {
            cancelledQuestions = Array(repeating: false, count: Int(numberOfQuestions))
        }
    }

    private func adjustCorrectAnswerMatrix() {
        if correctAnswerMatrix.count != Int(numberOfQuestions) || correctAnswerMatrix.first?.count != Int(numberOfAnswers) {
            correctAnswerMatrix = Array(repeating: Array(repeating: false, count: Int(numberOfAnswers)), count: Int(numberOfQuestions))
        }
    }
    
    private var hasValidCorrectAnswers: Bool {
        for row in correctAnswerMatrix {
            if !row.contains(true) {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                
                MainText(text: "Crear plantilla",
                         textColor: Color("AppPrimaryColor"),
                         font: .title2)
                .padding(.bottom)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        MainTextField(placeholder: "Nombre de la plantilla",
                                      text: $templateName,
                                      autoCapitalize: false,
                                      autoCorrection: false)
                        
                        MainDatePicker(selectedDate: $selectedDate)
                        
                        MainNumberPicker(placeholder: "Número de preguntas",
                                         minValue: 1,
                                         maxValue: 100,
                                         selectedValue: Binding(
                                                                get: { numberOfQuestions },
                                                                set: { numberOfQuestions = Int16($0); adjustCancelledQuestions(); adjustCorrectAnswerMatrix() }
                                                        ))
                        
                        MainNumberPicker(placeholder: "Número de respuestas",
                                         minValue: 2,
                                         maxValue: 8,
                                         selectedValue: Binding(
                                                                get: { numberOfAnswers },
                                                                set: { numberOfAnswers = Int16($0); adjustCorrectAnswerMatrix() }
                                                        ))
                        
                        
                        MainToggle(placeholder: "¿Más de una respuesta correcta?",
                                   isPressed: $moreThanOneAnswer,
                                   pressedText: "Sí",
                                   nonPressedText: "No")
                        
                        MainNumberTextField(placeholder: "Puntuación por respuesta correcta",
                                            number: $correctAnswerScore)
                        
                        MainNumberTextField(placeholder: "Penalización por respuesta incorrecta",
                                            number: $wrongAnswerPenalty)
                        
                        MainNumberTextField(placeholder: "Penalización por respuesta en blanco",
                                            number: $blankAnswerPenalty)
                        
                      
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
                                                
                        Spacer()
                    }
                }
                
                MainButton(title: "Guardar", action: {
                    viewModel.createAnswerTemplate(name: templateName,
                                                   date: selectedDate,
                                                   numberOfQuestions: numberOfQuestions,
                                                   numberOfAnswersPerQuestion: numberOfAnswers,
                                                   multipleCorrectAnswers: moreThanOneAnswer,
                                                   scoreCorrectAnswer: correctAnswerScore,
                                                   penaltyIncorrectAnswer: wrongAnswerPenalty,
                                                   penaltyBlankAnswer: blankAnswerPenalty,
                                                   cancelledQuestions: cancelledQuestions,
                                                   correctAnswerMatrix: correctAnswerMatrix)
                    
                    initFields()
                    
                }, disabled: isTemplateValid || !hasValidCorrectAnswers)
            }
            .padding()
            .onChange(of: numberOfQuestions) {
                adjustCancelledQuestions()
                adjustCorrectAnswerMatrix()
            }
            .onChange(of: numberOfAnswers) { 
                adjustCorrectAnswerMatrix()
            }
        }
    }
}
