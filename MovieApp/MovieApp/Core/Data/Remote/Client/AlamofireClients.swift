//
//  AlamofireHttpClients.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 20/01/25.
//

import Alamofire
import RxSwift
import SwiftUI

protocol HttpClient {
    func load(url: URL, method: String) -> Observable<Data>
}

class AlamofireClients: HttpClient {
    func load(url: URL, method: String) -> Observable<Data> {
        return Observable<Data>.create { observer in
            AF.request(url, method: HTTPMethod(rawValue: method))
                .responseData { result in
                    switch result.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let failure):
                        observer.onError(failure)
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
}

extension AlamofireClients {
//    func buildURL(_ endpoint: String, params: [String: String]) -> URL {
//        var urlComponents = URLComponents()
//        urlComponents.host = baseURL
//        urlComponents.path = endpoint
//        urlComponents.queryItems = params.map({ URLQueryItem(name: $0, value: $1) })
//        
//        guard let url = urlComponents.url else {
//            fatalError("Invalid URL components: \(urlComponents)")
//        }
//        return url
//        
//        
//    }
}
