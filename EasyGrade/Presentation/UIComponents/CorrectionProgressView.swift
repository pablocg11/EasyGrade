
import SwiftUI

struct CorrectionProgressView: View {
    @State private var examCorrectionScore: Double = 0.0
    var progress: Double
    var limit: Double
    
    private var progressColor: Color {
        progress < (0.5 * limit) ? .red : .green
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: examCorrectionScore / limit)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: -90))
            
            Text("\(String(format: "%.2f", progress))")
                .font(.largeTitle)
                .bold()
                .foregroundColor(progressColor)
        }
        .padding(40)
        .onAppear {
            animateProgress()
        }
    }
    
    private func animateProgress() {
        withAnimation(.easeInOut(duration: 1.5)) {
            examCorrectionScore = progress
        }
    }
}
