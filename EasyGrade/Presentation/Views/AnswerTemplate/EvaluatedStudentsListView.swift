
import SwiftUI

struct EvaluatedStudentsListView: View {
    @ObservedObject var viewModel: ListEvaluatedStudentsViewModel
    let template: ExamTemplate
    
    init(viewModel: ListEvaluatedStudentsViewModel, template: ExamTemplate) {
        self.viewModel = viewModel
        self.template = template
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                MainLoading()
            } else if viewModel.evaluatedStudents.isEmpty {
                EmptyListView(description: "Aún no hay estudiantes evaluados",
                              icon: "graduationcap")
            } else {
                VStack(spacing: 16) {
                    List {
                        ForEach(viewModel.evaluatedStudents, id: \.id) { student in
                            NavigationLink(destination: EditEvaluatedStudentView(
                                viewModel: viewModel,
                                student: student,
                                template: template
                            )) {
                                EvaluatedStudentRow(student: student)
                            }
                        }
                        .onDelete(perform: deleteStudent)
                        
                        statisticsView
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            if let errorMessage = viewModel.errorMessage {
                ErrorView(errorMessage: errorMessage, action: {})
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.exportEvaluatedStudents(template: template)
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
                .disabled(viewModel.evaluatedStudents.isEmpty)
            }
        }
        .onAppear {
            viewModel.onAppear(template: template)
        }
        .navigationTitle(template.name)
    }
    
    private var statisticsView: some View {
        HStack {
            statisticCard(icon: "person.3.fill", count: viewModel.evaluatedStudents.count, label: "Evaluados", color: .blue)
            statisticCard(icon: "checkmark.seal.fill", count: approvedStudents.count, label: "Aprobados", color: .green)
            statisticCard(icon: "xmark.seal.fill", count: notApprovedStudents.count, label: "Suspensos", color: .red)
        }
    }
    
    private func statisticCard(icon: String, count: Int, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            HStack {
                Image(systemName: icon)
                    .font(.callout)
                    .foregroundColor(color)
                Text("\(count)")
                    .font(.callout)
                    .fontWeight(.bold)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var approvedStudents: [EvaluatedStudent] {
        viewModel.evaluatedStudents.filter { $0.score ?? 0 >= 5 }
    }
    
    private var notApprovedStudents: [EvaluatedStudent] {
        viewModel.evaluatedStudents.filter { $0.score ?? 0 < 5 }
    }
    
    private func deleteStudent(at offsets: IndexSet) {
        offsets.forEach { index in
            let studentToDelete = viewModel.evaluatedStudents[index]
            viewModel.deleteEvaluatedStudent(evaluatedStudent: studentToDelete, template: template)
        }
        viewModel.evaluatedStudents.remove(atOffsets: offsets)
    }
}
