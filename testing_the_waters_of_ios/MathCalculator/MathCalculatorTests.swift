//
//  CalculatorTests.swift
//  testing_the_waters_of_iosTests
//
//  Created by Kostas Kremizas on 03/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest
@testable import testing_the_waters_of_ios

class MathCalculatorTests: XCTestCase {
    
    var sut: MathCalculator!
    
    override func setUp() {
        sut = MathCalculator()
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    private func assertFibonacci(_ input: Int, is expectedValue: UInt, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.fibonacci(input), expectedValue, file: file, line: line)
    }
    
    func test1stFibonacci() {
        assertFibonacci(0, is: 0)
    }

    func test2ndFibonacci() {
        assertFibonacci(1, is: 1)
    }

    func test3rdFibbonacci() {
        assertFibonacci(2, is: 0 + 1)
    }
    
    func testFibonacciPerformance() {
        measure {
            _ = sut.fibonacci(30)
        }
    }
}
