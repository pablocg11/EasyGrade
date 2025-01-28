import SwiftUI

struct ExamTemplateListView: View {
    @ObservedObject var viewModel: ListExamTemplateViewModel
    @ObservedObject var editViewModel: EditExamTemplateViewModel
    @ObservedObject var deleteViewModel: DeleteExamTemplateViewModel
    @ObservedObject var listEvaluatedStudentsViewModel: ListEvaluatedStudentsViewModel

    init(viewModel: ListExamTemplateViewModel, editViewModel: EditExamTemplateViewModel, deleteViewModel: DeleteExamTemplateViewModel, listEvaluatedStudentsViewModel: ListEvaluatedStudentsViewModel) {
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
                        if viewModel.ExamTemplateList.isEmpty {
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
                                    ForEach(viewModel.ExamTemplateList, id: \.id) { template in
                                        NavigationLink(destination: EvaluatedStudentFactory().createView(for: template)){
                                            ExamTemplateCard(editViewModel: editViewModel,
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
