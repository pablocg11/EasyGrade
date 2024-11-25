
import SwiftUI

struct CorrectionProgressView: View {
    @State private var examCorrectionScore: Double = 0.0
    var progress: Double
    var limit: Double
    
    private var progressColor: Color {
        examCorrectionScore < (0.5 * limit) ? .red : .green
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: examCorrectionScore / 100.0)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: -90))
            
            Text("\(String(format: "%.1f", progress))%")
                .font(.largeTitle)
                .bold()
                .foregroundColor(progressColor)
        }
        .padding(100)
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

#Preview {
    CorrectionProgressView(progress: 70.5, limit: 100.0)
}
