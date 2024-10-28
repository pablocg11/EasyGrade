
import SwiftUI

struct MainView: View {
    let createAnswerTemplateFactory: CreateAnswerTemplateFactory
    let listAnswerTemplateFactory: ListAnswerTemplateFactory

    var body: some View {
        TabView {
            createAnswerTemplateFactory.createView()
                .tabItem {
                    Label("Nueva plantilla", systemImage: "plus.app")
                }
            
            listAnswerTemplateFactory.createView()
                .tabItem {
                    Label("Plantillas", systemImage: "list.bullet.rectangle.portrait.fill")
                }
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor(Color("AppSecondaryColor"))
        }
        .accentColor(Color("AppPrimaryColor"))
        
    }
}

