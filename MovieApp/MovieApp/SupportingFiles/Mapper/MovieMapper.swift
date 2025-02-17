//
//  NowPlayingMapper.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import Foundation
import CoreData

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
        MovieDetailModel(
            id: movieResponse.id,
            title: movieResponse.title,
            overview: movieResponse.overview,
            backdropPath: movieResponse.backdropPath,
            posterPath: movieResponse.posterPath,
            releaseDate: movieResponse.releaseDate,
            voteAverage: movieResponse.voteAverage,
            tagline: movieResponse.tagline,
            runtime: movieResponse.runtime,
            voteCount: movieResponse.voteCount,
            genres: movieResponse.genres,
            productionCompanies: movieResponse.productionCompanies
        )
    }
    
    static func mapMovieDetailDomainToEntity(movie: MovieDetailModel) -> MoviesEntity {
        let entity = MoviesEntity()
        entity.movie_id = String(movie.id)
        entity.title = movie.title
        entity.overview = movie.overview
        entity.release_date = movie.releaseDate
        entity.poster_path = movie.posterPath
        entity.backdrop_path = movie.backdropPath
        entity.average = movie.voteAverage
        
        return entity
    }
    
    
    static func mapMovieDetailEntityToDomain(movie entity: MovieEntity) -> MovieDetailModel {
        
        MovieDetailModel(
            id: Int(entity.movie_id),
            title: entity.title ?? "",
            overview: entity.overview ?? "",
            backdropPath: entity.backdrop_path ?? "",
            posterPath: entity.poster_path ?? "",
            releaseDate: entity.release_date ?? "",
            voteAverage: entity.average
        )
    }
    
    static func mapMovieDetailEntityToDomain(movieEntity: [MoviesEntity]) -> [MovieDetailModel] {
        return movieEntity.map { movieEntity in
            var domain = MovieDetailModel()
            domain.id = Int(movieEntity.movie_id) ?? 0
            domain.title = movieEntity.title
            domain.overview = movieEntity.overview
            domain.releaseDate = movieEntity.release_date
            domain.posterPath = movieEntity.poster_path
            domain.backdropPath = movieEntity.backdrop_path
            domain.voteAverage = movieEntity.average
            return domain
        }
    }
}
