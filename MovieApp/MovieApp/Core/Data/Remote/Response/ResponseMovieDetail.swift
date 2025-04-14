//
//  ResponseMovieDetail.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import Foundation

struct ResponseMovieDetail: Codable {
    let adult: Bool
    let backdropPath: String
    let belongsToCollection: BelongsToCollection
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID: String
    let originCountry: [String]
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.backdropPath = try container.decode(String.self, forKey: .backdropPath)
        self.belongsToCollection = container.decodeDynamicModel(BelongsToCollection.self, forKey: .belongsToCollection)
        self.budget = try container.decode(Int.self, forKey: .budget)
        self.genres = try container.decode([Genre].self, forKey: .genres)
        self.homepage = try container.decode(String.self, forKey: .homepage)
        self.id = try container.decode(Int.self, forKey: .id)
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.originCountry = try container.decode([String].self, forKey: .originCountry)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.productionCompanies = try container.decode([ProductionCompany].self, forKey: .productionCompanies)
        self.productionCountries = try container.decode([ProductionCountry].self, forKey: .productionCountries)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.revenue = try container.decode(Int.self, forKey: .revenue)
        self.runtime = try container.decode(Int.self, forKey: .runtime)
        self.spokenLanguages = try container.decode([SpokenLanguage].self, forKey: .spokenLanguages)
        self.status = try container.decode(String.self, forKey: .status)
        self.tagline = try container.decode(String.self, forKey: .tagline)
        self.title = try container.decode(String.self, forKey: .title)
        self.video = try container.decode(Bool.self, forKey: .video)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
}

struct BelongsToCollection: Codable, DefaultInitializable {
    let id: Int
    let name, posterPath, backdropPath: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    init(
        id: Int = 0,
        name: String = "",
        posterPath: String = "",
        backdropPath: String = ""
    ) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
    
    init() {
        self.init(name: "")
    }
}

struct Genre: Codable {
    public let id: Int
    public let name: String
}

struct ProductionCompany: Codable {
    public let id: Int
    public let logoPath, name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    internal init(
        id: Int = 0,
        logoPath: String = "",
        name: String = "",
        originCountry: String = ""
    ) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.logoPath = container.decodeDynamicString(forKey: .logoPath)
        self.name = try container.decode(String.self, forKey: .name)
        self.originCountry = try container.decode(String.self, forKey: .originCountry)
    }
}

struct ProductionCountry: Codable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
