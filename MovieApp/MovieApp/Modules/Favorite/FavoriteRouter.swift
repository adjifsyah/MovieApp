//
//  FavoriteRouter.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import SwiftUI
import Core
import Movie

class FavoriteRouter {
    func makeDetailView(id movieID: Int, isFromFavorite: Bool = false, onDelete: (() -> Void)? = nil) -> some View  {
        let useCase: Interactor<Int, DetailMovieModel, GetMovieDetailRepository<GetDetailMoviesDataSource, GetFavoriteMoviesLocaleDataSource, DetailMovieTransform>>  = Injection().provideDetailUseCases()
//        let presenter = MovieDetailPresenter(movieID: movieID, useCase: useCase)
        let presenter: GetDetailMoviePresenter<Interactor<Int, DetailMovieModel, GetMovieDetailRepository<GetDetailMoviesDataSource, GetFavoriteMoviesLocaleDataSource, DetailMovieTransform>>> = .init(id: movieID, movieUseCase: useCase)
        return MovieDetailScreen(presenter: presenter)
    }
}
