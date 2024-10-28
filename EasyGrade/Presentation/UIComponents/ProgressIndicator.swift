
import SwiftUI

struct ProgressIndicator: View {
    @Binding var currentPhase: Int
    let totalPhases: Int

    var body: some View {
        HStack {
            ForEach(0..<totalPhases, id: \.self) { index in
                Circle()
                    .fill(index <= currentPhase ? Color("AppPrimaryColor") : Color(.systemGray4))
                    .frame(width: 10, height: 10)
                    .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 0.5))
                    .animation(.easeInOut, value: currentPhase)
                    .padding(5)
            }
        }
    }
}


