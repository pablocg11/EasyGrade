import SwiftUI

struct AnswerTemplateCard: View {
    
    @ObservedObject var editViewModel: EditAnswerTemplateViewModel
    @ObservedObject var deleteViewModel: DeleteAnswerTemplateViewModel
    @ObservedObject var listViewModel: ListAnswerTemplateViewModel
    @ObservedObject var listEvaluatedStudentsViewModel: ListEvaluatedStudentsViewModel
    
    var template: AnswerTemplate
    @State private var navigateToEdit = false
    @State private var nagivateToList = false
    
    var firstWord: String {
        return template.name.split(separator: " ").first.map(String.init)?.uppercased() ?? ""
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    MainText(text: template.name,
                             textColor: Color("AppPrimaryColor"),
                             font: .callout,
                             fontWeight: .semibold)
                    
                    MainText(text: DateFormatterUtility.shared.string(from: template.date),
                             textColor: Color("AppPrimaryColor"),
                             font: .subheadline)
                }
                
                Spacer()
                
            }
            .swipeActions(allowsFullSwipe: false) {
                Button {
                    navigateToEdit = true
                } label: {
                    Label("Editar", systemImage: "pencil")
                }
                .tint(.blue)
                
                Button(role: .destructive) {
                    deleteViewModel.deleteAnswerTemplate(templateId: template.id)
                    listViewModel.getAllAnswerTemplate()
                } label: {
                    Label("Borrar", systemImage: "trash")
                }
                
                Button {
                    nagivateToList = true
                } label: {
                    Label("Ver", systemImage: "eye")
                }
            }
            .navigationDestination(isPresented: $navigateToEdit) {
                AnswerTemplateEditView(viewModel: editViewModel,
                                       template: template)
                .onDisappear {
                    listViewModel.getAllAnswerTemplate()
                }
            }
            .navigationDestination(isPresented: $nagivateToList) {
                EvaluatedStudentsListView(viewModel: listEvaluatedStudentsViewModel,
                                          template: template)
            }
        }
        .padding()
        .background(Color("AppSecondaryColor"))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
