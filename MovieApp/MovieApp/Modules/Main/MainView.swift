//
//  MainView.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI

struct MainView: View {
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
        HomeScreen(
            viewModel: HomeVM(
                repository: MovieRepository.sharedInstance(
                    RemoteDataSource(
                        configuration: .shared,
                        client: AlamofireClients()
                    )
                )
            )
        )
    }
    
    var favorite: some View {
        FavoriteScreen()
    }
    
    var profile: some View {
        ProfileScreen()
    }
}

#Preview {
    MainView()
}
