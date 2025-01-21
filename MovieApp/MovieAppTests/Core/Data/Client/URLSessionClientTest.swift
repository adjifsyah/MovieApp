//
//  URLSessionClientTest.swift
//  MovieAppTests
//
//  Created by Apple Josal on 21/01/25.
//

import XCTest
import RxSwift
@testable import MovieApp

class URLSessionClientTest: XCTestCase {
    var client: URLSessionClient!
    var disposeBag: DisposeBag!
    var session: URLSession!
    var url: URL!
    
    override func setUp() {
        super.setUp()
        client = URLSessionClient()
        url = URL(string: "https://example.com")
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        session = nil
        client = nil
        url = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testURLSession_whenGivenData_shouldReturnValue() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        client = URLSessionClient(session: session)
        
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
    
    func testURLSession_whenGivenDefaultData_shouldReturnError() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        client = URLSessionClient(session: session)
        
        let mockResponseData = "{\"status\": \"ok\"}"
        
        MockURLProtocol.stubError = NSError(domain: "MockError", code: 1001, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Observer should receive data")
        
        client.load(url: url, method: "GET", params: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onError: { error in
                    let error = (error as NSError)
                    print("ERROR MESSAGE ", error.domain)
                    XCTAssertEqual((error as NSError).domain, "MockError")
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
    }
}
