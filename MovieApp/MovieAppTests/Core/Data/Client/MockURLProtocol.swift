//
//  MockURLProtocol.swift
//  MovieAppTests
//
//  Created by Apple Josal on 21/01/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var stubError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.stubError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else if let data = MockURLProtocol.stubResponseData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }

    
    override func stopLoading() { }
}
