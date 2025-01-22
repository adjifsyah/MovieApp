//
//  MovieDetailVM.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import SwiftUI
import RxSwift

class MovieDetailVM: ObservableObject {
    private let repository: MovieRepositoryLmpl
    private let disposeBag = DisposeBag()
    private let movieID: Int
    
    init(movieID id: Int, repository: MovieRepositoryLmpl) {
        self.movieID = id
        self.repository = repository
    }
}
