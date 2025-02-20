//
//  LocaleDataSource.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 23/01/25.
//

import Foundation
import RxSwift

protocol LocaleDataSourceLmpl {
    func getFavorite() -> Observable<[MovieDetailModel]>
    func getDetailFavorite(movieID: Int) -> Observable<MovieDetailModel>
    func addFavorite(movie: MovieDetailModel) -> Observable<Bool>
    func deleteFavorite(movieId: Int) -> Observable<Bool>
}
