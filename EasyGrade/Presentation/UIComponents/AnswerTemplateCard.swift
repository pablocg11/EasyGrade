
import SwiftUI

struct AnswerTemplateCard: View {
    
    @ObservedObject var editViewModel: EditAnswerTemplateViewModel
    @ObservedObject var deleteViewModel: DeleteAnswerTemplateViewModel
    @ObservedObject var listViewModel: ListAnswerTemplateViewModel
    @ObservedObject var listEvaluatedStudentsViewModel: ListEvaluatedStudentsViewModel
    
    var template: AnswerTemplate
    @State private var navigateToEdit = false
    @State private var navigateToList = false
    
    var body: some View {
        VStack {
            headerContent
                .swipeActions(allowsFullSwipe: false) {
                    editButton
                    deleteButton
                    viewButton
                }
                .navigationDestination(isPresented: $navigateToEdit) {
                    AnswerTemplateEditView(viewModel: editViewModel, template: template)
                        .onDisappear {
                            listViewModel.getAllAnswerTemplate()
                        }
                }
                .navigationDestination(isPresented: $navigateToList) {
                    EvaluatedStudentsListView(viewModel: listEvaluatedStudentsViewModel, template: template)
                }
        }
        .padding()
        .background(Color("AppSecondaryColor"))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var headerContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                MainText(
                    text: template.name,
                    textColor: Color("AppPrimaryColor"),
                    font: .callout,
                    fontWeight: .bold
                )

                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "calendar")
                                .foregroundColor(Color(.gray))
                        MainText(
                            text: DateFormatterUtility.shared.string(from: template.date),
                            textColor: Color(.gray),
                            font: .caption,
                            fontWeight: .regular
                        )
                    }
                    
                    Spacer()

                    HStack(spacing: 3) {
                        Image(systemName: "questionmark.circle")
                                .foregroundColor(Color(.gray))
                        MainText(
                            text: "\(template.numberOfQuestions) preguntas",
                            textColor: Color(.gray),
                            font: .caption,
                            fontWeight: .regular
                        )
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 3) {
                        Image(systemName: "square.stack")
                            .foregroundColor(Color(.gray))
                        MainText(
                            text: "\(template.numberOfAnswersPerQuestion) respuestas",
                            textColor: Color(.gray),
                            font: .caption,
                            fontWeight: .regular
                        )
                    }
                }
                .padding(5)
            }
            
            Spacer()
        }
    }
    
    private var editButton: some View {
        Button {
            navigateToEdit = true
        } label: {
            Label("Editar", systemImage: "pencil")
        }
        .tint(.blue)
    }
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            deleteViewModel.deleteAnswerTemplate(templateId: template.id)
            listViewModel.answerTemplateList.removeAll { $0.id == template.id }
        } label: {
            Label("Borrar", systemImage: "trash")
        }
    }
    
    private var viewButton: some View {
        Button {
            navigateToList = true
        } label: {
            Label("Ver", systemImage: "eye")
        }
    }
}
