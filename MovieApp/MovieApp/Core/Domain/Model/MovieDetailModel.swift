//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import Foundation

struct MovieDetailModel {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    let tagline: String
    let voteCount: Int
    
    init(
        id: Int = 0,
        title: String = "",
        overview: String = "",
        backdropPath: String = "",
        posterPath: String = "",
        releaseDate: String = "",
        id: Int = 0
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
}

struct GenreModel: Codable {
    let id: Int
    let name: String
}
