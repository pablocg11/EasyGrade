import SwiftUI

struct ContentView: View {
    let createExamTemplateView: CreateExamTemplateView
    let listExamTemplateView: ExamTemplateListView

    var body: some View {
        ZStack {
            Color("AppBackgroundColor")
                .ignoresSafeArea()
            
            TabView {
                createExamTemplateView
                    .tabItem {
                        Label("Nueva plantilla", systemImage: "plus.app")
                    }
                
                listExamTemplateView
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
