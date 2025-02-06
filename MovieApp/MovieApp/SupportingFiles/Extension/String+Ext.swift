//
//  String+Ext.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 22/01/25.
//

import Foundation

extension String {
    var toImageURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500" + self)
    }
}
