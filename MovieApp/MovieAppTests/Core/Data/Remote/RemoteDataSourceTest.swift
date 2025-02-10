//
//  RemoteDataSourceTest.swift
//  MovieAppTests
//
//  Created by Apple Josal on 21/01/25.
//

import XCTest
import RxSwift
@testable import MovieApp

final class RemoteDataSourceTest: XCTestCase {
    var remoteDataSource: RemoteDataSourceLmpl!
    var httpClient: AlamofireClients!
    var mockClient: MockHttpClient!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockClient = MockHttpClient()
        httpClient = AlamofireClients()
        let networkConfig = NetworkConfiguration.shared
        remoteDataSource = RemoteDataSource.sharedInstance(networkConfig, mockClient)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        remoteDataSource = nil
        mockClient = nil
        disposeBag = nil
        super.tearDown()
    }

    func testLoad_whenValidResponse_shouldReturnDecodedObject() {
        // Given
        let expectedModel = ResponseNowPlaying(page: 1, results: [ResponseMovie(id: 4)], totalPages: 10, totalResults: 10)
        let jsonData = try! JSONEncoder().encode(expectedModel)
        mockClient.data = jsonData

        remoteDataSource.load(endpoint: "/nowPlaying", method: "GET", params: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (decodedObject: ResponseNowPlaying) in
                
                XCTAssertEqual(decodedObject.page, expectedModel.page)
                XCTAssertEqual(decodedObject.results.first?.id, expectedModel.results.first?.id)
            }, onError: { error in
                XCTFail("Expected successful response, got error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
//    func testLoad_whenGivenParamsLanguage_shouldReturnLangID() {
//        let endpoint = "/nowPlaying"
//        let params = ["language": "id-ID"]
//        mockClient.data = dataNowPlaying
//        
//        if let url = remoteDataSource.constructURL(for: endpoint, params: params) {
//            XCTAssert(url.absoluteString.contains("id-ID"))
//        }
//    }

    func testLoad_whenInvalidResponse_shouldReturnDecodingError() {
        // Given
        let invalidData = Data() // Invalid data that cannot be decoded
        mockClient.data = invalidData

        // When
        remoteDataSource.load(endpoint: "/nowPlaying", method: "GET", params: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (decodedObject: ResponseNowPlaying) in
                XCTFail("Expected error, but got success")
            }, onError: { error in
                // Then
                let nsError = error as NSError
                XCTAssertEqual(nsError.domain, "DecodingError")
            })
            .disposed(by: disposeBag)
    }

    func testLoad_whenNoData_shouldReturnError() {
        // Given
        mockClient.data = nil
        mockClient.error = NSError(domain: "MockError", code: 1001, userInfo: nil)

        // When
        remoteDataSource.load(endpoint: "/nowPlaying", method: "GET", params: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (decodedObject: ResponseNowPlaying) in
                XCTFail("Expected error, but got success")
            }, onError: { error in
                // Then
                XCTAssertEqual((error as NSError).code, 1001)
            })
            .disposed(by: disposeBag)
    }
    
    func testLoad_whenInvalidURL_shouldReturn404Error() {
        let invalidEndpoint = "invalidEndpoint//"
        mockClient.data = dataNowPlaying
        
        remoteDataSource.load(endpoint: invalidEndpoint, method: "GET", params: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (_: ResponseNowPlaying) in }, onError: { error in
                XCTAssertEqual((error as NSError).code, 404)
                XCTAssertEqual((error as NSError).domain, "api.themoviedb.orginvalidEndpoint//")
            })
            .disposed(by: disposeBag)
    }
}

extension RemoteDataSourceTest {
    class MockHttpClient: HttpClient {
        var data: Data?
        var error: Error?
        
        func load(url: URL, method: String, params: [String: String]?) -> Observable<Data> {
            if let error = error {
                return Observable.error(error)
            }
            
            guard let data = data else {
                return Observable.error(NSError(domain: "MockError", code: 404, userInfo: nil))
            }
            
            return Observable.just(data)
        }
    }
}

var dataNowPlaying = """
    {
      "dates": {
        "maximum": "2025-01-22",
        "minimum": "2024-12-11"
      },
      "page": 1,
      "results": [
        {
          "adult": false,
          "backdrop_path": "/rDa3SfEijeRNCWtHQZCwfbGxYvR.jpg",
          "genre_ids": [
            28,
            878,
            12,
            14,
            53
          ],
          "id": 539972,
          "original_language": "en",
          "original_title": "Kraven the Hunter",
          "overview": "Kraven Kravinoff's complex relationship with his ruthless gangster father, Nikolai, starts him down a path of vengeance with brutal consequences, motivating him to become not only the greatest hunter in the world, but also one of its most feared.",
          "popularity": 4616.142,
          "poster_path": "/i47IUSsN126K11JUzqQIOi1Mg1M.jpg",
          "release_date": "2024-12-11",
          "title": "Kraven the Hunter",
          "video": false,
          "vote_average": 6.521,
          "vote_count": 656
        }
      ],
      "total_pages": 191,
      "total_results": 3820
    }
""".data(using: .utf8)!

var emptyDataNowPlaying = """
    {
      "dates": {
        "maximum": "2025-01-22",
        "minimum": "2024-12-11"
      },
      "page": 1,
      "results": [
      ],
      "total_pages": 191,
      "total_results": 3820
    }
""".data(using: .utf8)!
