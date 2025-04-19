//
//  HomeRouter.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import SwiftUI
import Core
import Movie

class HomeRouter {
    func makeDetailView(id movieID: Int, isFromFavorite: Bool = false, onDelete: (() -> Void)? = nil) -> some View {
        let useCase: Interactor<DetailMovieModel, DetailMovieModel, GetMovieDetailRepository<GetDetailMoviesDataSource, GetFavoriteMoviesLocaleDataSource, DetailMovieTransform>>  = Injection().provideDetailUseCases()
        let favUseCase: Interactor<DetailMovieModel, DetailMovieModel, GetFavoriteMovieRepository<GetFavoriteMoviesLocaleDataSource, DetailMovieTransform>> = Injection().provideFavDetailUseCases()
        
        let presenter: GetDetailMoviePresenter<
            Interactor<DetailMovieModel, DetailMovieModel, GetMovieDetailRepository<GetDetailMoviesDataSource, GetFavoriteMoviesLocaleDataSource, DetailMovieTransform>>,
            Interactor<DetailMovieModel, DetailMovieModel, GetFavoriteMovieRepository< GetFavoriteMoviesLocaleDataSource, DetailMovieTransform>>> = .init(id: movieID, movieUseCase: useCase, favoriteUseCase: favUseCase)
        return MovieDetailScreen(presenter: presenter)
            .navigationBarBackButtonHidden()
    }
}
