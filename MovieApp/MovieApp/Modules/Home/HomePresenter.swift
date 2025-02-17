//
//  HomePresenter.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import SwiftUI
import RxSwift

class HomePresenter: ObservableObject {
    @Published var movies: [MovieModel] = []
    @Published var visibilty: Visibility = .visible
    @Published var screenSize: CGSize = .init()
    
    let router: HomeRouter = HomeRouter()
    
    private let useCase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomePresenter {
    func fetchNowPlaying() {
        useCase.fetchMovies()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                self?.movies = result
            }
            .disposed(by: disposeBag)
    }
    
    func navigateTo<Content: View>(
        movie: MovieModel,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeDetailView(id: movie.id)) {
            content()
        }
    }
}
