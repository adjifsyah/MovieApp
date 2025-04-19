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
let detailUseCase: Interactor<DetailMovieModel, DetailMovieModel, GetMovieDetailRepository<GetDetailMoviesDataSource, GetFavoriteMoviesLocaleDataSource, DetailMovieTransform>> = Injection.init().provideDetailUseCases()

let favUseCase: Interactor<DetailMovieModel, [DetailMovieModel], GetListFavoriteMovieRepository<GetFavoriteMoviesLocaleDataSource, FavoriteMovieTransform>> = Injection.init().provideFavoriteUseCases()

@main
struct MovieAppApp: App {
    let homePresent = GetListPresenter(useCase: homeUseCase)
    let favoritePresenter = GetListPresenter(useCase: favUseCase)
    
    var body: some Scene {
        WindowGroup {
            MainView(
                homePresenter: homePresent,
                favoritePresenter: favoritePresenter
            )
        }
    }
}
