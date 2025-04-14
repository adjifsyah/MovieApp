//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import Foundation
import RxSwift
import Core

protocol MovieRepositoryLmpl {
    func fetchMovies() -> Observable<[MovieModel]>
    func fetchMovieDetail(id: Int) -> Observable<MovieDetailModel>
    
    func getFavorite() -> Observable<[MovieDetailModel]>
    func addMovieToFavorite(movie: MovieDetailModel) -> Observable<MovieDetailModel>
    func deleteFavorite(id movieID: Int) -> Observable<Bool>
    
}

class MovieRepository: MovieRepositoryLmpl {
    typealias MovieInstance = (LocaleDataSourceLmpl, RemoteDataSourceLmpl) -> MovieRepository
    private let remote: RemoteDataSourceLmpl
    private let locale: LocaleDataSourceLmpl
    
    private init(locale: LocaleDataSourceLmpl, remote: RemoteDataSourceLmpl) {
        self.remote = remote
        self.locale = locale
    }
    
    static let sharedInstance: MovieInstance = { locale, remote in
        return MovieRepository(locale: locale, remote: remote)
    }
}

extension MovieRepository {
    func fetchMovies() -> Observable<[MovieModel]> {
        self.remote.load(endpoint: "/now_playing", method: "GET", params: nil)
            .map { (response: ResponseNowPlaying) in
                MovieMapper.mapMovieResponseToDomain(input: response.results)
            }
            .filter({ !$0.isEmpty})
    }
    
    func fetchMovieDetail(id: Int) -> Observable<MovieDetailModel> {
        self.remote.load(endpoint: "/\(id)", method: "GET", params: nil)
            .map { (response: ResponseMovieDetail) in
                MovieMapper.mapMovieDetailResponseToDomain(input: response)
            }
    }
    
    func getFavorite() -> Observable<[MovieDetailModel]> {
        self.locale.getFavorite()
    }
    
    func getFavoriteDetail(movieID id: Int) -> Observable<MovieDetailModel> {
        self.locale.getDetailFavorite(movieID: id)
    }
    
    func addMovieToFavorite(movie: MovieDetailModel) -> Observable<MovieDetailModel> {
        self.locale.addFavorite(movie: movie)
            .flatMap { isSuccess in
                if isSuccess {
                    return self.fetchMovieDetail(id: movie.id)
                } else {
                    return Observable.error(DatabaseError.requestFailed)
                }
            }
    }
    
    func deleteFavorite(id movieID: Int) -> Observable<Bool> {
        return self.locale.deleteFavorite(movieId: movieID)
    }
    
}
