//
//  HomeUseCase.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    func fetchMovies() -> Observable<[MovieModel]>
}
