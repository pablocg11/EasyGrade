import SwiftUI

struct AnswerTemplateListView: View {
    
    let cameraUsageFactory = CameraUsageFactory()

    @ObservedObject var viewModel: ListAnswerTemplateViewModel
    @ObservedObject var editViewModel: EditAnswerTemplateViewModel
    @ObservedObject var deleteViewModel: DeleteAnswerTemplateViewModel
    
    init(viewModel: ListAnswerTemplateViewModel,
         editViewModel: EditAnswerTemplateViewModel,
         deleteViewModel: DeleteAnswerTemplateViewModel) {
        
        self.viewModel = viewModel
        self.editViewModel = editViewModel
        self.deleteViewModel = deleteViewModel
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.showLoading {
                ProgressView("Cargando...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()

            }
            else{
                VStack {
                    if viewModel.answerTemplateList.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "list.bullet.clipboard")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("AppPrimaryColor"))
                                .frame(maxWidth: 80, maxHeight: 80)
                            
                            MainText(text: "No hay plantillas disponibles",
                                     textColor: Color("AppPrimaryColor"),
                                     font: .title3)
                        }
                    } else {
                        VStack(alignment: .leading) {
                            MainText(text: "Lista de plantillas",
                                     textColor: Color("AppPrimaryColor"),
                                     font: .title2)
                            .padding(.top)
                            .padding(.horizontal)
                            
                            List {
                                ForEach(viewModel.answerTemplateList, id: \.id) { template in
                                    NavigationLink (destination: MainEvaluationView(cameraUsageFactory: cameraUsageFactory,
                                                                                    template: template)){
                                        AnswerTemplateCard(cameraUsageFactory: cameraUsageFactory,
                                                           editViewModel: editViewModel,
                                                           deleteViewModel: deleteViewModel,
                                                           listViewModel: viewModel,
                                                           template: template)
                                    }
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(PlainListStyle())
                            .refreshable {
                                viewModel.getAllAnswerTemplate()
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.getAllAnswerTemplate()
                }
            }
        }
    }
}
