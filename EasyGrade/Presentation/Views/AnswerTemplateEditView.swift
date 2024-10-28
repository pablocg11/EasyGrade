import SwiftUI

struct AnswerTemplateEditView: View {
    
    @ObservedObject var viewModel: EditAnswerTemplateViewModel
    @Environment(\.presentationMode) var presentationMode
    var template: AnswerTemplate
    
    @State private var templateName: String
    @State private var selectedDate: Date
    @State private var numberOfQuestions: Int16
    @State private var numberOfAnswers: Int16
    @State private var moreThanOneAnswer: Bool
    @State private var correctAnswerScore: Double
    @State private var wrongAnswerPenalty: Double
    @State private var blankAnswerPenalty: Double
    @State private var cancelledQuestions: [Bool]
    @State private var correctAnswerMatrix: [[Bool]]

    init(viewModel: EditAnswerTemplateViewModel, template: AnswerTemplate) {
        self.viewModel = viewModel
        self.template = template
        
        _templateName = State(initialValue: template.name)
        _selectedDate = State(initialValue: template.date)
        _numberOfQuestions = State(initialValue: template.numberOfQuestions)
        _numberOfAnswers = State(initialValue: template.numberOfAnswersPerQuestion)
        _moreThanOneAnswer = State(initialValue: template.multipleCorrectAnswers)
        _correctAnswerScore = State(initialValue: template.scoreCorrectAnswer)
        _wrongAnswerPenalty = State(initialValue: template.penaltyIncorrectAnswer)
        _blankAnswerPenalty = State(initialValue: template.penaltyBlankAnswer)
        _cancelledQuestions = State(initialValue: template.cancelledQuestions)
        _correctAnswerMatrix = State(initialValue: template.correctAnswerMatrix)
    }

    private var isTemplateValid: Bool {
        return templateName.isEmpty || correctAnswerScore == 0 || wrongAnswerPenalty == 0
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
        VStack {
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
                                         set: { newValue in
                                             numberOfQuestions = Int16(newValue)
                                             adjustCancelledQuestions()
                                             adjustCorrectAnswerMatrix()
                                         }
                                     ))
                    
                    MainNumberPicker(placeholder: "Número de respuestas",
                                     minValue: 2,
                                     maxValue: 8,
                                     selectedValue: Binding(
                                         get: { numberOfAnswers },
                                         set: { newValue in
                                             numberOfAnswers = Int16(newValue)
                                             adjustCorrectAnswerMatrix()
                                         }
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
                }
                
                Spacer()
            }
            .onChange(of: viewModel.showLoading) { 
                if viewModel.errorMessage == nil {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            MainButton(title: "Guardar", action: saveTemplate, disabled: isTemplateValid || !hasValidCorrectAnswers)
        }
        .padding()
        .navigationTitle("Edición de plantilla")
    }

    private func saveTemplate() {
        let updatedTemplate = AnswerTemplate(
            id: template.id,
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
        viewModel.updateAnswerTemplate(template: updatedTemplate)
    }
}
