//
//  NowPlayingMapper.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import Foundation

final class MovieMapper {
    static func mapMovieResponseToDomain(
        input categoryResponses: [ResponseMovie]
    ) -> [MovieModel] {
        categoryResponses.map { movieResponse in
            MovieModel(
                id: movieResponse.id,
                title: movieResponse.title,
                overview: movieResponse.overview,
                backdropPath: movieResponse.backdropPath,
                posterPath: movieResponse.posterPath,
                releaseDate: movieResponse.releaseDate
            )
        }
    }
    static func mapMovieDetailResponseToDomain(
        input movieResponse: ResponseMovieDetail
    ) -> MovieDetailModel {
//        categoryResponses.map { movieResponse in
            MovieDetailModel(
                id: movieResponse.id,
                title: movieResponse.title,
                overview: movieResponse.overview,
                backdropPath: movieResponse.backdropPath,
                posterPath: movieResponse.posterPath,
                releaseDate: movieResponse.releaseDate,
                voteAverage: movieResponse.voteAverage,
                tagline: movieResponse.tagline,
                voteCount: movieResponse.voteCount
            )
//        }
    }
}
