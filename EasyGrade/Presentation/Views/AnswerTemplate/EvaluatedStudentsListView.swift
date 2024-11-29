
import SwiftUI

struct EvaluatedStudentsListView: View {
    @ObservedObject var viewModel: ListEvaluatedStudentsViewModel
    let template: AnswerTemplate
    
    init(viewModel: ListEvaluatedStudentsViewModel, template: AnswerTemplate) {
        self.viewModel = viewModel
        self.template = template
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                MainLoading()
            } else if viewModel.evaluatedStudents.isEmpty {
                EmptyListView(description: "Aun no hay estudiantes evaluados")
            } else {
                List {
                    ForEach(viewModel.evaluatedStudents, id: \.self) { student in
                        EvaluatedStudentRow(student: student)
                    }
                    .onDelete(perform: deleteStudent)
                    
                    HStack {
                        MainText(text: "🧑‍🎓 \(viewModel.evaluatedStudents.count)", font: .callout)
                        
                        let passedStudentsCount = viewModel.evaluatedStudents.filter { $0.score ?? 0 >= 5 }.count
                        MainText(text: "✅ \(passedStudentsCount)", font: .callout)
                        
                        let notPassedStudentsCount = viewModel.evaluatedStudents.filter { $0.score ?? 0 < 5 }.count
                        MainText(text: "❌ \(notPassedStudentsCount)", font: .callout)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                }
                
                MainButton(title: "Exportar",
                           action: {
                    viewModel.exportEvaluatedStudents(template: template)
                },
                           disabled: viewModel.isLoading)
                .padding()
                .background(.white)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            viewModel.onAppear(template: template)
        }
        .navigationTitle(template.name)
    }
    
    private func deleteStudent(at offsets: IndexSet) {
        offsets.forEach { index in
            let studentToDelete = viewModel.evaluatedStudents[index]
            viewModel.deleteEvaluatedStudent(evaluatedStudent: studentToDelete, template: template)
        }
        viewModel.evaluatedStudents.remove(atOffsets: offsets)
    }
}
