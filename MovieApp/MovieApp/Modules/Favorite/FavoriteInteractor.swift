//
//  FavoriteInteractor.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import RxSwift

protocol FavoriteUseCase {
    func getFavorite() -> Observable<[MovieDetailModel]>
}

class FavoriteInteractor: FavoriteUseCase {
    let repository: MovieRepositoryLmpl
    init(repository: MovieRepositoryLmpl) {
        self.repository = repository
    }
    
    func getFavorite() -> Observable<[MovieDetailModel]> {
        repository.getFavorite()
    }
}
