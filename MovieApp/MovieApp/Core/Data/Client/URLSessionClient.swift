//
//  URLSessionClient.swift
//  MovieApp
//
//  Created by Apple Josal on 21/01/25.
//

import RxSwift
import SwiftUI

class URLSessionClient: HttpClient {
    
    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func load(url: URL, method: String, params: [String : String]?) -> Observable<Data> {
        return Observable<Data>.create { observer in
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            self.session.dataTask(with: request) { data, response, error in
                if let error {
                    observer.onError(error)
                }
                
                if let data {
                    observer.onNext(data)
                    observer.onCompleted()
                }
            }
            .resume()
            
            return Disposables.create()
        }
    }
}

