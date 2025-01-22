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
            
            favorite
                .tabItem {
                    Label("Favorite", systemImage: "star")
                }
            
            profile
                .tabItem {
                    Label("About", systemImage: "person")
                }
        }
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
