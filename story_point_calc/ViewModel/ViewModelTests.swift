//
//  ViewModelTests.swift
//  story_point_calcTests
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest
@testable import story_point_calc

class ViewModelTests: XCTestCase {
    
    func testCalculateButtonTapRequestsPointCalculation() {
        // Arrange
        let storyPointCalc = SynchronousStoryPointsCalculatorSpy(storyPoints: 3)
        let sut = ViewModel(storyPointCalc)
        
        // Act
        sut.calculateButtonTapped()
        
        // Assert
        XCTAssertTrue(storyPointCalc.requestedCalculation)
    }
    
    func testTheDefaultLabelCopy() {
        // Arrange
        let storyPointCalc = SynchronousStoryPointsCalculatorSpy(storyPoints: 3)
        let sut = ViewModel(storyPointCalc)
        var labelText = ""
        
        // Act
        let expectation = self.expectation(description: "getting initial text")
        sut.labelText { text in
            labelText = text
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(labelText, "Estimates are damn hard! Right? Let us do the math for you!")
    }
    
    func testTheLabelCopyAfterTheCalculationForZeroPoints() {
        // Arrange
        let storyPointCalc = SynchronousStoryPointsCalculatorSpy(storyPoints: 0)
        let sut = ViewModel(storyPointCalc)
        var labelText = ""
        
        var expectation = self.expectation(description: "getting initial text")

        sut.labelText { (text) in
            labelText = text
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        // Act
        
        expectation = self.expectation(description: "getting udpated text")

        sut.calculateButtonTapped()
        
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(labelText, "Done! What's next?")
    }
    
    func testTheLabelCopyAfterTheCalculationForSmallStories() {
        assertTextIsCorrectForEasyStories(expectedPoints: 1)
        assertTextIsCorrectForEasyStories(expectedPoints: 2)
        assertTextIsCorrectForEasyStories(expectedPoints: 3)
        assertTextIsCorrectForEasyStories(expectedPoints: 5)
    }
    
    func testTheLabelCopyAfterTheCalculationForBigStories() {
        assertTextIsCorrectForBigStories(expectedPoints: 8)
        assertTextIsCorrectForBigStories(expectedPoints: 13)
        assertTextIsCorrectForBigStories(expectedPoints: 21)
    }
    
    func testTheTextOnError() {
        // Arrange
        let sut = ViewModel(ErroringStoryPointsCalculatorStub())
        var labelText = ""
        var expectation = self.expectation(description: "getting initial text")
        sut.labelText { (text) in
            labelText = text
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        expectation = self.expectation(description: "getting updated text")

        // Act
        sut.calculateButtonTapped()
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Assert
        XCTAssertEqual(labelText, "🤭 It turns out we underestimated the difficulty of calculating story points! Please try again!")
    }
    
    func testThatButtonIsDisabledWhileLoading() {
        assertButtonIsDisabledOnlyWhileLoading { (calculator) in
            calculator.resolve(with: 3)
        }
    }
    
    func testThatButtonIsEnabledAgainOnError() {
        assertButtonIsDisabledOnlyWhileLoading { (calculator) in
            calculator.resolveWithError()
        }
    }
    
    func testIsLoadingWhileLoading() {
        assertIsLoadingOnlyWhileLoading { asyncCalculator in
            asyncCalculator.resolve(with: 1)
        }
    }
    
    func testThatButtonStopsLoadingAgainOnError() {
        assertIsLoadingOnlyWhileLoading { (calculator) in
            calculator.resolveWithError()
        }
    }
    
    // MARK: Helpers
    
    private func assertTextIsCorrectForEasyStories(expectedPoints: Int, file: StaticString = #file, line: UInt = #line) {
        // Arrange
        let storyPointCalc = SynchronousStoryPointsCalculatorSpy(storyPoints: expectedPoints)
        let sut = ViewModel(storyPointCalc)
        var labelText = ""
        
        var expectation = self.expectation(description: "getting initial text")
        
        sut.labelText { (text) in
            labelText = text
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Act
        expectation = self.expectation(description: "getting updated text")
        sut.calculateButtonTapped()
        

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(labelText, "This story is a definite \(expectedPoints) pointer! I double checked!", file: file, line: line)
    }
    
    private func assertTextIsCorrectForBigStories(expectedPoints: Int, file: StaticString = #file, line: UInt = #line) {
        // Arrange
        let storyPointCalc = SynchronousStoryPointsCalculatorSpy(storyPoints: expectedPoints)
        let sut = ViewModel(storyPointCalc)
        var labelText = ""
        
        var expectation = self.expectation(description: "getting initial text")

        sut.labelText { (text) in
            labelText = text
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        expectation = self.expectation(description: "getting updated text")
        
        // Act
        sut.calculateButtonTapped()
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(labelText, "Wow! I think it's a \(expectedPoints)! Maybe we should break this down into more stories?", file: file, line: line)
    }
    
    private func assertButtonIsDisabledOnlyWhileLoading(resolveAction: (AsynchronousStoryPointsCalculatorSpy) -> Void) {
        let calculator = AsynchronousStoryPointsCalculatorSpy()
        
        // Injecting serial queue in order to be able to make
        // async code sync for our tests
        let queue = DispatchQueue(label: "isLoading")
        let sut = ViewModel(calculator, queue)
        var isButtonEnabled = true
        sut.isButtonEnabled { (isEnabled) in
            isButtonEnabled = isEnabled
        }
        
        // By doing this we are actually waiting for the
        // serial queue to execute any pending work and then
        // move on to the assertion
        queue.sync {}
        
        XCTAssertTrue(isButtonEnabled)
        
        // Act
        sut.calculateButtonTapped()
        
        queue.sync {}
        
        // Assert
        XCTAssertFalse(isButtonEnabled)
        
        // Step after assert? Quite sure this is not best practise. Not sure how to do this elegantly without BDD scopes
        
        
        resolveAction(calculator)
        
        queue.sync {}
        
        // Assert... again
        XCTAssertTrue(isButtonEnabled)
    }
    
    private func assertIsLoadingOnlyWhileLoading(resolveAction: (AsynchronousStoryPointsCalculatorSpy) -> Void) {
        // Arrange
        let asyncCalculator = AsynchronousStoryPointsCalculatorSpy()
        let queue = DispatchQueue(label: "isLoading")
        let sut = ViewModel(asyncCalculator, queue)
        var isLoading: Bool = false
        
        sut.isLoading { (loading) in
            isLoading = loading
        }
        
        queue.sync {}
        
        XCTAssertFalse(isLoading)
        
        // Act
        sut.calculateButtonTapped()
        
        queue.sync {}
        
        XCTAssertTrue(isLoading)
        
        // Response comes
        resolveAction(asyncCalculator)
        
        queue.sync {}
        
        XCTAssertFalse(isLoading)
    }

}

class SynchronousStoryPointsCalculatorSpy: StoryPointsCalculatorProtocol {
    private let storyPoints: Int
    
    public init(storyPoints: Int) {
        self.storyPoints = storyPoints
    }
    
    var requestedCalculation = false
    
    func calculate(completion: @escaping (Int?, Error?) -> Void) {
        requestedCalculation = true
        completion(storyPoints, nil)
    }
}

class AsynchronousStoryPointsCalculatorSpy: StoryPointsCalculatorProtocol {
    
    var requestedCalculationCompletion: ((Int?, Error?) -> Void)?
    
    func calculate(completion: @escaping (Int?, Error?) -> Void) {
        requestedCalculationCompletion = completion
    }
    
    func resolve(with number: Int) {
        requestedCalculationCompletion?(number, nil)
    }
    
    func resolveWithError() {
        requestedCalculationCompletion?(nil, RandomNumberFetcher.genericError)
    }
}

class ErroringStoryPointsCalculatorStub: StoryPointsCalculatorProtocol {
    func calculate(completion: @escaping (Int?, Error?) -> Void) {
        completion(nil, RandomNumberFetcher.genericError)
    }
}
