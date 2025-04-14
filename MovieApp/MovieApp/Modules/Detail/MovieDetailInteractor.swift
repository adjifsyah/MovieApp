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

protocol MovieDetailUseCase {
    func getFavorite(id movieID: Int) -> Observable<MovieDetailModel>
    func fetchMovieDetail(id movieID: Int) -> Observable<MovieDetailModel>
    func addFavorite(movie: MovieDetailModel) -> Observable<MovieDetailModel>
    func deleteFavorite(id movieID: Int) -> Observable<Bool>
}

class MovieDetailInteractor: MovieDetailUseCase {
    let repository: MovieRepositoryLmpl
     
    init(repository: MovieRepositoryLmpl) {
        self.repository = repository
    }
    
    func getFavorite(id movieID: Int) -> Observable<MovieDetailModel> {
        repository.getFavorite()
            .map { favorite in
                favorite.first(where: { movieID == $0.id }) ?? MovieDetailModel()
            }
    }
    
    func fetchMovieDetail(id movieID: Int) -> Observable<MovieDetailModel> {
        repository.fetchMovieDetail(id: movieID)
    }
    
    func addFavorite(movie: MovieDetailModel) -> Observable<MovieDetailModel> {
        repository.addMovieToFavorite(movie: movie)
    }
    
    func deleteFavorite(id movieID: Int) -> RxSwift.Observable<Bool> {
        repository.deleteFavorite(id: movieID)
    }
    
  
}

final class Injection: NSObject {
    private func provideRepository() -> MovieRepositoryLmpl {
        let locale = RealmDataSource(realm: try? Realm())
        
        let alamofireClient = AlamofireClient()
        let remote = RemoteDataSource.sharedInstance(.shared, alamofireClient)
        
        return MovieRepository.sharedInstance(
            locale,
            remote
        )
    }
    
    func provideHomeUseCase() -> HomeUseCase {
        return HomeInteractor(repository: provideRepository())
    }
    
    func provideFavoriteUseCase() -> FavoriteUseCase {
        return FavoriteInteractor(repository: provideRepository())
    }
    
    func provideDetailsUseCase() -> MovieDetailUseCase {
        return MovieDetailInteractor(
            repository: provideRepository()
        )
    }
  
    func provideHomeUseCases<U: UseCases>() -> U where U.Request == URLRequest, U.Response == [MovieDomainModel] {
        let client = AlamofireClient()
        let remote = GetMoviesDataSource(client: client)
        let mapper = MovieTransform()
        let repository = MoviesRepositories(remote: remote, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
    
    func provideDetailUseCases<U: UseCases>() -> U where U.Request == Int, U.Response == DetailMovieModel {
        let client = AlamofireClient()
        let remoteDS = RemoteDataSource.sharedInstance(.shared, client)
        let realm = try! Realm()
        let remote = GetDetailMoviesDataSource(remote: remoteDS)
        let locale = GetFavoriteMoviesLocaleDataSource(realm: realm)
        let mapper = DetailMovieTransform()
        let repository = GetMovieDetailRepository(remote: remote, locale: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
}
