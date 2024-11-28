
import SwiftUI

struct EvaluatedStudentsListView: View {
    @ObservedObject var viewModel: ListEvaluatedStudentsViewModel
    @State var template: AnswerTemplate

    init(viewModel: ListEvaluatedStudentsViewModel, template: AnswerTemplate) {
        self.viewModel = viewModel
        self.template = template
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Cargando...")
            } else if let students = viewModel.answerTemplate?.evaluatedStudents, !students.isEmpty {
                List {
                    ForEach(students, id: \.id) { student in
                        VStack(alignment: .leading) {
                            Text(student.name)
                                .font(.headline)
                            Text("DNI: \(student.dni)")
                                .font(.subheadline)
                            Text("Puntaje: \(student.score!, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("No hay estudiantes evaluados.")
            }
        }
        .onAppear {
            viewModel.onAppear(template.id)
        }
        .navigationTitle("Estudiantes Evaluados")
    }
}
