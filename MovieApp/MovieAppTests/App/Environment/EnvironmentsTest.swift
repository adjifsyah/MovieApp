//
//  EnvironmentsTest.swift
//  MovieAppTests
//
//  Created by Apple Josal on 21/01/25.
//

import XCTest
@testable import MovieApp

final class EnvironmentsTest: XCTestCase {
    
    func testApiKey_whenKeyExists_shouldReturnApiKey() {
        XCTAssertEqual(Environments.apiKey, "d658f72bdc0a8c1c659568cd3ca359b2")
    }
}
