//
//  MovieModel.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 21/01/25.
//

import Foundation

public struct MovieModel: Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let overview: String
    public let backdropPath: String
    public let posterPath: String
    public let releaseDate: String
    
    public init(
        id: Int,
        title: String,
        overview: String,
        backdropPath: String,
        posterPath: String,
        releaseDate: String
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
}

//public struct CategoryDomainModel: Equatable, Identifiable {
//    public let id: String
//       public let title: String
//       public let image: String
//       public let description: String
//    
//    public init(id: String, title: String, image: String, description: String) {
//        self.id = id
//        self.title = title
//        self.image = image
//        self.description = description
//    }
//}
