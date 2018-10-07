//
//  RandomNumberResponseTests.swift
//  testing_the_waters_of_iosTests
//
//  Created by Kostas Kremizas on 07/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest
@testable import testing_the_waters_of_ios

class RandomNumberResponseTests: XCTestCase {
    func testJSONDecoding() {
        // Arrange
        let jsonString = """
        {"jsonrpc":"2.0","result":{"random":{"data":[1,9,8,9,7,10,9,2,7,3],"completionTime":"2018-10-06 16:53:14Z"},"bitsUsed":33,"bitsLeft":1860160,"requestsLeft":393819,"advisoryDelay":1140},"id":11958}
        """
        
        let data = jsonString.data(using: .utf8)!
        
        // Act
        let sut = try? JSONDecoder().decode(RandomNumberFetcher.Response.self, from: data)
        
        XCTAssertNotNil(sut)
    }
}
