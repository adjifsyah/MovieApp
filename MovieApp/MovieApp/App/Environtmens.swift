//
//  Environmens.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 20/01/25.
//

import Foundation

enum Environments {
    enum Keys {
        enum Plist {
            static let apiKeyMovieDB = "Api Key"
        }
    }
    
    private static let infoDictionary: [String : Any] = {
        Bundle.main.infoDictionary ?? [:]
    }()
    
    static let apiKey: String = {
        Environments.infoDictionary[Keys.Plist.apiKeyMovieDB] as? String ?? ""
    }()
    
}
