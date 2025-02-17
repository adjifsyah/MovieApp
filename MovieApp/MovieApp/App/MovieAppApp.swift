//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Apple Josal on 21/01/25.
//

import SwiftUI

@main
struct MovieAppApp: App {
    let homePresenter = HomePresenter(useCase: Injection().provideHomeUseCase())
    let favoritePresenter = FavoritePresenter(useCases: Injection().provideFavoriteUseCase())
    
    var body: some Scene {
        WindowGroup {
            MainView(
                homePresenter: homePresenter,
                favoritePresenter: favoritePresenter
            )
        }
    }
}
