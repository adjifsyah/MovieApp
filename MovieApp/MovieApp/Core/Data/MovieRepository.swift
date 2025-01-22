//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import Foundation
import RxSwift

protocol MovieRepositoryLmpl {
    func fetchMovies() -> Observable<[MovieModel]>
    func fetchMovieDetail(id: Int) -> Observable<MovieDetailModel>
}

class MovieRepository: MovieRepositoryLmpl {
    typealias MovieInstance = (RemoteDataSource) -> MovieRepository
    private let remote: RemoteDataSourceLmpl
    
    private init(remote: RemoteDataSourceLmpl) {
        self.remote = remote
    }
    
    static let sharedInstance: MovieInstance = { remote in
        return MovieRepository(remote: remote)
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
}
