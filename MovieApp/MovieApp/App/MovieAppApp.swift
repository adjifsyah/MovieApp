//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Apple Josal on 21/01/25.
//

import SwiftUI
import Core
import Movie

let homeUseCase: Interactor<URLRequest, [MovieDomainModel], MoviesRepositories<GetMoviesDataSource, MovieTransform>> = Injection.init().provideHomeUseCases()

@main
struct MovieAppApp: App {
    let homePresent = GetListPresenter(useCase: homeUseCase)
//    let homePresenter = HomePresenter(useCase: Injection().provideHomeUseCase())
    let favoritePresenter = FavoritePresenter(useCases: Injection().provideFavoriteUseCase())
    
    var body: some Scene {
        WindowGroup {
            MainView(
                homePresenter: homePresent,
                favoritePresenter: favoritePresenter
            )
        }
    }
}
