//
//  CustomError+Ext.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 23/01/25.
//

import Foundation

enum DatabaseError: LocalizedError {
    case invalidInstance
    case invalidFetchMovieDetail
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance: return "Database can't instance."
        case .invalidFetchMovieDetail: return "Database can't fetch detail movie."
        case .requestFailed: return "Your request failed."
        }
    }
}
