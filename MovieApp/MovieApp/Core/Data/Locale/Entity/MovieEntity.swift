//
//  MoviesEntity.swift
//  MovieApp
//
//  Created by Apple Josal on 17/02/25.
//

import Foundation
import RealmSwift

class MoviesEntity: Object {
    @objc dynamic var movie_id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var average: Double = 0.0
    @objc dynamic var release_date: String = ""
    @objc dynamic var poster_path: String = ""
    @objc dynamic var backdrop_path: String = ""
    
    override static func primaryKey() -> String? {
        return "movie_id"
    }
}
