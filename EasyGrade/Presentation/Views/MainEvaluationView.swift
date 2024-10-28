

import SwiftUI

struct MainEvaluationView: View {
    
    let cameraUsageFactory: CameraUsageFactory
    var template: AnswerTemplate

    
    var body: some View {
        NavigationView {
            VStack {
                cameraUsageFactory.createView()
            }
        }
        .padding()
        .navigationTitle(template.name)
    }
}
