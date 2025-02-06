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
    func load(url: URL, method: String, params: [String: String]?) -> Observable<Data>
}

class AlamofireClients: HttpClient {
    var session: Session?
    
    init(URLSessionConfig configuration: URLSessionConfiguration = URLSessionConfiguration.default, timeoutInterval: TimeInterval = 120) {
            configuration.timeoutIntervalForRequest = timeoutInterval
            configuration.timeoutIntervalForResource = timeoutInterval
            self.session = Session(configuration: configuration)
    }
    
    func load(url: URL, method: String, params: [String: String]?) -> Observable<Data> {
        return Observable<Data>.create { observer in
            self.session?.request(url, method: HTTPMethod(rawValue: method), parameters: params)
                .responseData { result in
                    switch result.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let failure):
                        observer.onError(failure)
                    }
                }
            
            return Disposables.create()
        }
    }
}
