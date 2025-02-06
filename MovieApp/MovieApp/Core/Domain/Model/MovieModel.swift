//
//  MovieModel.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import Foundation

struct MovieModel {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String
    let posterPath: String
    let releaseDate: String
    
    init(
        id: Int = 0,
        title: String = "",
        overview: String = "",
        backdropPath: String = "",
        posterPath: String = "",
        releaseDate: String = ""
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
}
