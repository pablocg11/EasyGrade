import SwiftUI

struct ScoreComponent: View {
    @Binding var score: Float

    var body: some View {
        VStack {
            Text(String(format: "%.2f", score))
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: {
                    score -= 0.1
                }) {
                    Text("-")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }

                Button(action: {
                    score += 0.1
                }) {
                    Text("+")
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ScoreComponent(score: .constant(0.33))
}
