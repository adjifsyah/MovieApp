//
//  FavoriteRouter.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import SwiftUI

class FavoriteRouter {
    func makeDetailView(id movieID: Int, isFromFavorite: Bool = false, onDelete: (() -> Void)? = nil) -> some View  {
        let useCase = Injection().provideDetailsUseCase()
        let detailPresenter = MovieDetailPresenter(movieID: movieID, isFromFavorite: isFromFavorite, useCase: useCase, onDelete: onDelete)
        return MovieDetailScreen(presenter: detailPresenter)
    }
}
