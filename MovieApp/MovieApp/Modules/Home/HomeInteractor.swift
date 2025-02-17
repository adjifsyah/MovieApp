//
//  HomeInteractor.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import Foundation
import RxSwift

class HomeInteractor: HomeUseCase {
    let repository: MovieRepositoryLmpl
    
    init(repository: MovieRepositoryLmpl) {
        self.repository = repository
    }
    
    func fetchMovies() -> Observable<[MovieModel]> {
        repository.fetchMovies()
    }
}
