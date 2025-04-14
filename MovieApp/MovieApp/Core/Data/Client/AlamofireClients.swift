//
//  AlamofireHttpClients.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 20/01/25.
//

import Alamofire
import RxSwift
import SwiftUI
import Core
//protocol HttpClient {
//    func load(url: URL, method: String, params: [String: String]?) -> Observable<Data>
//}

//public class AlamofireClients: HttpClient {
//    var session: Session?
//    
//    public init(URLSessionConfig configuration: URLSessionConfiguration = URLSessionConfiguration.default, timeoutInterval: TimeInterval = 120) {
//            configuration.timeoutIntervalForRequest = timeoutInterval
//            configuration.timeoutIntervalForResource = timeoutInterval
//            self.session = Session(configuration: configuration)
//    }
//    
//    public func load(request: URLRequest) -> RxSwift.Observable<Data> {
//        return Observable<Data>.create { observer in
//            
//            self.session?.request(request)
//                .responseData { result in
//                    switch result.result {
//                    case .success(let data):
//                        observer.onNext(data)
//                        observer.onCompleted()
//                    case .failure(let failure):
//                        observer.onError(failure)
//                    }
//                }
//            
//            return Disposables.create()
//        }
//    }
//}
