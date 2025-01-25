//
//  MainView.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var homePresenter: HomePresenter
    @EnvironmentObject var favoritePresenter: FavoritePresenter
    
    var body: some View {
        TabView {
            home
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
            
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

#Preview {
    MainView()
}
