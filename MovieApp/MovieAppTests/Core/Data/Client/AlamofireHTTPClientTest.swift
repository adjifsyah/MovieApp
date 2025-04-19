//
//  AlamofireHTTPClientTest.swift
//  MovieAppTests
//
//  Created by Apple Josal on 21/01/25.
//

import XCTest
import RxSwift
import Alamofire
import Movie
import Core
@testable import MovieApp

class AlamofireHTTPClientTest: XCTestCase {
    var client: AlamofireClient!
    var url: URL!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        client = AlamofireClient()
        url = URL(string: "https://example.com")
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        MockURLProtocol.stubError = nil
        client = nil
        url = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testAlamofire_whenGivenData_shouldReturnTrue() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        client = AlamofireClient(URLSessionConfig: config)
        
        let mockResponseData = "{\"status\": \"ok\"}"
        MockURLProtocol.stubResponseData = mockResponseData.data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "Observer should receive data")
        
//        load(url: url, method: "GET", params: nil)
        client.load(request: try! URLRequest(url: url, method: .get))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { data in
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dict = json as? [String: String] {
                        XCTAssertEqual(dict["status"], "ok")
                        expectation.fulfill()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAlamofire_whenGivenNoData_shouldReturnError() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        client = AlamofireClient(URLSessionConfig: config)
        
        MockURLProtocol.stubError = NSError(domain: "MockError", code: 1001)
        
        let expectation = XCTestExpectation(description: "Observer should receive data")
        
        client.load(request: try! URLRequest(url: url, method: .get))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onError: { error in
                    if let afError = error as? AFError,
                       let underlyingError = afError.underlyingError as NSError? {
                        XCTAssertEqual(underlyingError.domain, "MockError")
                        XCTAssertEqual(underlyingError.code, 1001)
                        expectation.fulfill()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
}
