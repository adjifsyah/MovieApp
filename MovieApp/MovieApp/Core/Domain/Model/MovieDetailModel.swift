//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import Foundation

struct MovieDetailModel {
    var id: Int
    var title: String
    var overview: String
    var backdropPath: String
    var posterPath: String
    var releaseDate: String
    var tagline: String
    var runtime: Int
    var voteAverage: Double
    var voteCount: Int
    var genres: [Genre]
    var productionCompanies: [ProductionCompany]
    
    init(
        id: Int = 0,
        title: String = "",
        overview: String = "",
        backdropPath: String = "",
        posterPath: String = "",
        releaseDate: String = "",
        voteAverage: Double = 0.0,
        tagline: String = "",
        runtime: Int = 0,
        voteCount: Int = 0,
        genres: [Genre] = [],
        productionCompanies: [ProductionCompany] = []
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.tagline = tagline
        self.runtime = runtime
        self.voteCount = voteCount
        self.genres = genres
        self.productionCompanies = productionCompanies
    }
}

struct GenreModel: Codable {
    let id: Int
    let name: String
}
