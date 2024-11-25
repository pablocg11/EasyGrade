
import SwiftUI

struct ContentView: View {
    let createAnswerTemplateView: CreateAnswerTemplateView
    let listAnswerTemplateView: AnswerTemplateListView

    var body: some View {
        TabView {
            createAnswerTemplateView
                .tabItem {
                    Label("Nueva plantilla", systemImage: "plus.app")
                }
            
            listAnswerTemplateView
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

