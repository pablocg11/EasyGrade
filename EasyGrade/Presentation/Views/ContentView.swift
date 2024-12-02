import SwiftUI

struct ContentView: View {
    let createAnswerTemplateView: CreateAnswerTemplateView
    let listAnswerTemplateView: AnswerTemplateListView

    var body: some View {
        ZStack {
            Color("AppBackgroundColor")
                .ignoresSafeArea()
            
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
            .accentColor(Color("AppPrimaryColor"))
            .onAppear {
                UITabBar.appearance().backgroundColor = UIColor(Color("AppSecondaryColor"))
            }
        }
    }
}
