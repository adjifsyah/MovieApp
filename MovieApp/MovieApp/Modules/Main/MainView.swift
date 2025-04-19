//
//  MainView.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI
import Core
import RxSwift
import Movie



struct MainView: View {
    @StateObject var mainVM: MainVM = MainVM()
    @State var homePresenter: GetListPresenter<URLRequest, MovieDomainModel, Interactor<URLRequest, [MovieDomainModel], MoviesRepositories<GetMoviesDataSource, MovieTransform>>>
    @State var favoritePresenter: GetListPresenter<DetailMovieModel, DetailMovieModel,
                                                   Interactor<DetailMovieModel, [DetailMovieModel], GetListFavoriteMovieRepository< GetFavoriteMoviesLocaleDataSource, FavoriteMovieTransform>>>
    
    var body: some View {
        TabView {
            HomeScreen(presenter: homePresenter)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
                .toolbar(mainVM.visibility, for: .tabBar)
                .environmentObject(mainVM)
            
            FavoriteScreen(presenter: favoritePresenter)
                .tabItem {
                    Label("Favorite", systemImage: "star")
                }
                .tag(2)
                .toolbar(mainVM.visibility, for: .tabBar)
                .environmentObject(mainVM)
            
            ProfileScreen()
                .tabItem {
                    Label("About", systemImage: "person")
                }
                .tag(3)
        }
        .preferredColorScheme(.light)
    }
}

class MainVM: ObservableObject {
    @Published var visibility: Visibility = .visible
    @Published var screenSize: CGSize = .init()
}
