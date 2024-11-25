
import SwiftUI

@main
struct ScanGraterApp: App {
    init() {
        ValueTransformer.setValueTransformer(BoolMatrixTransformer(),
                                             forName: NSValueTransformerName("BoolMatrixTransformer"))
        ValueTransformer.setValueTransformer(BoolArrayTransformer(),
                                             forName: NSValueTransformerName("BoolArrayTransformer"))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(createAnswerTemplateView: CreateAnswerTemplateFactory().createView(),
                        listAnswerTemplateView: ListAnswerTemplateFactory().createView())
        }
    }
}
