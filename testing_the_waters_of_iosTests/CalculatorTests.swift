//
//  CalculatorTests.swift
//  testing_the_waters_of_iosTests
//
//  Created by Kostas Kremizas on 03/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest

class Calculator {
    
    func fibonacci(_ n: Int) -> UInt {
        let result = (n <= 1) ? UInt(n) : fibonacci(n-1) + fibonacci(n-2)
        return result
    }
}

class CalculatorTests: XCTestCase {
    
    var sut: Calculator!
    
    override func setUp() {
        sut = Calculator()
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
