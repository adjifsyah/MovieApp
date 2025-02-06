//
//  MovieDetailInteractor.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 24/01/25.
//

import Foundation
import RxSwift

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
        let locale = CoreDataDataSource.sharedInstance
        
        let alamofireClient = AlamofireClients()
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
    
    
}
