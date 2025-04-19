//
//  Results+Ext.swift
//  MovieApp
//
//  Created by Apple Josal on 17/02/25.
//

import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }
}
