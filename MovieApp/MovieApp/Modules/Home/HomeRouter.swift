//
//  HomeRouter.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import SwiftUI

class HomeRouter {
    func makeDetailView(id movieID: Int, isFromFavorite: Bool = false, onDelete: (() -> Void)? = nil) -> some View {
        let useCase = Injection().provideDetailsUseCase()
        let presenter = MovieDetailPresenter(movieID: movieID, useCase: useCase)
        return MovieDetailScreen(presenter: presenter)
            .navigationBarBackButtonHidden()
    }
}
