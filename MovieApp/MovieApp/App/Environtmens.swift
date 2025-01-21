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
            static let apiKeyMovieDB = "API_KEY"
        }
    }
    
    private static let infoDictionary: [String : Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKey = Environments.infoDictionary[Keys.Plist.apiKeyMovieDB] as? String else {
            fatalError("BaseURL not set in plist for this environment")
        }
        
        return apiKey
    }()
    
}
