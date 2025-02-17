//
//  MainView.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainVM: MainVM = MainVM()
    @State var homePresenter: HomePresenter
    @State var favoritePresenter: FavoritePresenter
    
    var body: some View {
        TabView {
            home
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
                .toolbar(mainVM.visibility, for: .tabBar)
                .environmentObject(mainVM)
            
            favorite
                .tabItem {
                    Label("Favorite", systemImage: "star")
                }
                .tag(2)
            
            profile
                .tabItem {
                    Label("About", systemImage: "person")
                }
                .tag(3)
        }
        .preferredColorScheme(.light)
    }
    
    var home: some View {
        HomeScreen(presenter: homePresenter)
    }
    
    var favorite: some View {
        FavoriteScreen(presenter: favoritePresenter)
    }
    
    var profile: some View {
        ProfileScreen()
    }
}

class MainVM: ObservableObject {
    @Published var visibility: Visibility = .visible
}

#Preview {
    let homePresenter = HomePresenter(useCase: Injection().provideHomeUseCase())
    let favoritePresenter = FavoritePresenter(useCases: Injection().provideFavoriteUseCase())
    return MainView(homePresenter: homePresenter, favoritePresenter: favoritePresenter)
}
