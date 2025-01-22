//
//  HomeVM.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import SwiftUI
import RxSwift

class HomeVM: ObservableObject {
    @Published var movies: [MovieModel] = []
    
    @Published var screenSize: CGSize = .init()
    
    private let repository: MovieRepositoryLmpl
    private let disposeBag = DisposeBag()
    
    init(repository: MovieRepositoryLmpl) {
        self.repository = repository
    }
}

extension HomeVM {
    func fetchNowPlaying() {
        repository.fetchMovies()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                self?.movies = result
            }
            .disposed(by: disposeBag)
    }
    
    func navigateTo<Content: View>(movie: MovieModel, @ViewBuilder content: @escaping () -> Content) -> some View {
        NavigationLink {
            MovieDetailScreen(
                viewModel: MovieDetailVM(
                    movieID: movie.id,
                    repository: self.repository
                )
            )
        } label: {
            content()
        }

    }
    
    func imageURL(path: String) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w500" + path)
    }
}
