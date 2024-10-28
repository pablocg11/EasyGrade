
import SwiftUI

@main
struct ScanGraterApp: App {
    let createAnswerTemplateFactory = CreateAnswerTemplateFactory()
    let listAnswerTemplateFactory = ListAnswerTemplateFactory()

    init() {
        ValueTransformer.setValueTransformer(BoolMatrixTransformer(),
                                             forName: NSValueTransformerName("BoolMatrixTransformer"))
        ValueTransformer.setValueTransformer(BoolArrayTransformer(),
                                             forName: NSValueTransformerName("BoolArrayTransformer"))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(createAnswerTemplateFactory: createAnswerTemplateFactory,
                     listAnswerTemplateFactory: listAnswerTemplateFactory)
        }
    }
}
