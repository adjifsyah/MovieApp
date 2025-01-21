//
//  RemoteDataSource.swift
//  MovieApp
//
//  Created by Adji Firmansyah on 20/01/25.
//

import RxSwift
import SwiftUI

protocol RemoteDataSourceLmpl {
    func load<D: Decodable>(url: URL, method: String) -> Observable<D>
}

class RemoteDataSource: RemoteDataSourceLmpl {
    private let url: URL
    private let client: HttpClient
    
    init(url: URL, client: HttpClient) {
        self.url = url
        self.client = client
    }
    
    func load<D>(url: URL, method: String) -> Observable<D> where D : Decodable {
        return client.load(url: url, method: method)
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
}
                            
