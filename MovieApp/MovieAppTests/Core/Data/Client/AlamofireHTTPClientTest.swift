//
//  AlamofireHTTPClientTest.swift
//  MovieAppTests
//
//  Created by Apple Josal on 21/01/25.
//

import XCTest
import RxSwift
import Alamofire
@testable import MovieApp

class AlamofireHTTPClientTest: XCTestCase {
    var client: AlamofireClients!
    var url: URL!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        client = AlamofireClients()
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
        client = AlamofireClients(URLSessionConfig: config)
        
        let mockResponseData = "{\"status\": \"ok\"}"
        MockURLProtocol.stubResponseData = mockResponseData.data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "Observer should receive data")
        
        client.load(url: url, method: "GET", params: nil)
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
        client = AlamofireClients(URLSessionConfig: config)
        
        MockURLProtocol.stubError = NSError(domain: "MockErro", code: 1001)
        
        let expectation = XCTestExpectation(description: "Observer should receive data")
        
        client.load(url: url, method: "GET", params: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onError: { error in
                    if let afError = error as? AFError,
                       let underlyingError = afError.underlyingError as NSError? {
                        XCTAssertEqual(underlyingError.domain, "MockErrors")
                        XCTAssertEqual(underlyingError.code, 100)
                        expectation.fulfill()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
}
