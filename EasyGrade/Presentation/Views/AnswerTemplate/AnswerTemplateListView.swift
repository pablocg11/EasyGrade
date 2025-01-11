import SwiftUI

struct AnswerTemplateListView: View {
    @ObservedObject var viewModel: ListAnswerTemplateViewModel
    @ObservedObject var editViewModel: EditAnswerTemplateViewModel
    @ObservedObject var deleteViewModel: DeleteAnswerTemplateViewModel
    @ObservedObject var listEvaluatedStudentsViewModel: ListEvaluatedStudentsViewModel

    init(viewModel: ListAnswerTemplateViewModel, editViewModel: EditAnswerTemplateViewModel, deleteViewModel: DeleteAnswerTemplateViewModel, listEvaluatedStudentsViewModel: ListEvaluatedStudentsViewModel) {
        self.viewModel = viewModel
        self.editViewModel = editViewModel
        self.deleteViewModel = deleteViewModel
        self.listEvaluatedStudentsViewModel = listEvaluatedStudentsViewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showLoading {
                    MainLoading()
                }
                else {
                    VStack {
                        if viewModel.answerTemplateList.isEmpty {
                            EmptyListView(description: "Aún no hay plantillas disponibles",
                                          icon: "checklist")
                        } else {
                            VStack(alignment: .leading) {
                                MainText(text: "Lista de plantillas",
                                         textColor: Color("AppPrimaryColor"),
                                         font: .title2)
                                .padding(.top)
                                .padding(.horizontal)
                                
                                List {
                                    ForEach(viewModel.answerTemplateList, id: \.id) { template in
                                        NavigationLink(destination: EvaluatedStudentFactory().createView(for: template)){
                                            AnswerTemplateCard(editViewModel: editViewModel,
                                                                   deleteViewModel: deleteViewModel,
                                                                   listViewModel: viewModel,
                                                                   listEvaluatedStudentsViewModel: listEvaluatedStudentsViewModel,
                                                                   template: template)
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                }
                                .listStyle(PlainListStyle())
                                .refreshable {
                                    viewModel.onAppear()
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}
