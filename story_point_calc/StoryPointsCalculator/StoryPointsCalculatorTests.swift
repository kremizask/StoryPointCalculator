//
//  StoryPointsCalculatorTests.swift
//  story_point_calcTests
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest
@testable import story_point_calc

class StoryPointsCalculatorTests: XCTestCase {
    func testThatCalculeRequestsRandomNumberAndReturnsTheCorrespondingFibonacci() {
        
        // Arrange
        
        let randomFetcher = RandomFetcherSpy(result: 5)
        let sut = StoryPointsCalculator(randomFetcher)
        
        // Act
        var points: Int?
        var error: Error?
        sut.calculate() { (result, err) in
            points = result
            error = err
        }
        
        // Assert
        XCTAssertTrue(randomFetcher.numberRequested)
        XCTAssertNil(error)
        XCTAssertEqual(points, MathCalculator().fibonacci(5))
    }
}

class RandomFetcherSpy: RandomNumberFetcherProtocol {
    let result: Int
    var numberRequested = false
    
    public init(result: Int) {
        self.result = result
    }
    
    func fetchRandomNumber(completion: @escaping (Int?, Error?) -> Void) {
        numberRequested = true
        completion(result, nil)
    }
}
