
import SwiftUI

struct CancelledQuestionsView: View {
    
    @Binding var cancelledQuestions: [Bool]
    @Binding var numberOfQuestions: Int16

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(0..<Int(numberOfQuestions), id: \.self) { index in
                    MainToggle(placeholder: "Pregunta \(index + 1) anulada",
                               isPressed: $cancelledQuestions[index],
                               pressedText: "Sí",
                               nonPressedText: "No")
                }
            }
            .padding()
            .navigationTitle("Preguntas anuladas")
        }
    }
}
