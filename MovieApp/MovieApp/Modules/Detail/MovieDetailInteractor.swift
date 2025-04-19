//
//  MovieDetailInteractor.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import Foundation
import RxSwift
import RealmSwift
import Core
import Movie

final class Injection: NSObject {
    func provideHomeUseCases<U: UseCases>() -> U where U.Request == URLRequest, U.Response == [MovieDomainModel] {
        let client = AlamofireClient()
        let remote = GetMoviesDataSource(client: client)
        let mapper = MovieTransform()
        let repository = MoviesRepositories(remote: remote, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    
    func provideDetailUseCases<U: UseCases>() -> U where U.Request == DetailMovieModel, U.Response == DetailMovieModel {
        let client = AlamofireClient()
        let remoteDS = RemoteDataSource.sharedInstance(.shared, client)
        let realm = try! Realm()
        let remote = GetDetailMoviesDataSource(remote: remoteDS)
        let locale = GetFavoriteMoviesLocaleDataSource(realm: realm)
        let mapper = DetailMovieTransform()
        let repository = GetMovieDetailRepository(remote: remote, locale: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    
    func provideFavDetailUseCases<U: UseCases>() -> U where U.Request == DetailMovieModel, U.Response == DetailMovieModel {
        let client = AlamofireClient()
        let remoteDS = RemoteDataSource.sharedInstance(.shared, client)
        let realm = try! Realm()
        let remote = GetDetailMoviesDataSource(remote: remoteDS)
        let locale = GetFavoriteMoviesLocaleDataSource(realm: realm)
        let mapper = DetailMovieTransform()
        let repository = GetFavoriteMovieRepository(locale: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    
    func provideFavoriteUseCases<U: UseCases>() -> U where U.Request == DetailMovieModel, U.Response == [DetailMovieModel] {
        let realm = try! Realm()
        let locale = GetFavoriteMoviesLocaleDataSource(realm: realm)
        let mapper = FavoriteMovieTransform()
        let repository = GetListFavoriteMovieRepository(locale: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
}
