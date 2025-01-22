//
//  MovieDetailVM.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI
import RxSwift

class MovieDetailVM: ObservableObject {
    @Published var movieDetail: MovieDetailModel = .init()
    private let repository: MovieRepositoryLmpl
    private let disposeBag = DisposeBag()
    private let movieID: Int
    
    @Published var screenSize: CGSize = .zero
    
    init(movieID id: Int, repository: MovieRepositoryLmpl) {
        self.movieID = id
        self.repository = repository
//        fetchMovieDetail()
    }
    
    func fetchMovieDetail() {
        repository.fetchMovieDetail(id: movieID)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.movieDetail = result
            })
            .disposed(by: disposeBag)
    }
}
