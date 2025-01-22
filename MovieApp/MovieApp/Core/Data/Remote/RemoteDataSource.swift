//
//  RemoteDataSource.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 20/01/25.
//

import RxSwift
import SwiftUI

protocol RemoteDataSourceLmpl {
    func load<D: Decodable>(endpoint: String, method: String, params: [String: String]?) -> Observable<D>
}

class RemoteDataSource: RemoteDataSourceLmpl {
    private let configuration: NetworkConfiguration
    private let client: HttpClient
    
    init(configuration: NetworkConfiguration, client: HttpClient) {
        self.configuration = configuration
        self.client = client
    }
    
    func load<D>(endpoint: String, method: String, params: [String: String]? = nil) -> Observable<D> where D : Decodable {
        guard let url = constructURL(for: endpoint, params: params) else {
            return Observable.error(NSError(domain: configuration.host + endpoint, code: 404))
        }
        
        return client.load(url: url, method: method, params: params)
            .map { data in
                do {
                    // Coba untuk mendekode data JSON menjadi objek tipe D
                    let decodedObject = try JSONDecoder().decode(D.self, from: data)
                    return decodedObject
                } catch {
                    // Menangani error decoding jika gagal
                    throw NSError(domain: "DecodingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response data."])
                }
            }
            .catch { error in
                return Observable.error(error)
            }
    }
    
    internal func constructURL(for endpoint: String, params: [String: String]? = nil) -> URL? {
        guard endpoint.hasPrefix("/") || endpoint.isEmpty else {
            return nil
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = configuration.host
        components.path = endpoint.contains("/3/movie") ? endpoint : "/3/movie\(endpoint)"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: configuration.apiKey)
        ]
        
        guard let params else {
            return components.url
        }
        
        components.queryItems?.append(contentsOf: params.map {
            URLQueryItem(name: $0, value: $1)
        })
        
        return components.url
    }
}
                            
class NetworkConfiguration {
    static let shared = NetworkConfiguration()
    
    private init(
        host: String = "api.themoviedb.org",
        apiKey: String = Environments.apiKey
    ) {
        self.host = host
        self.apiKey = apiKey
    }
    
    var host: String
    var apiKey: String
}
