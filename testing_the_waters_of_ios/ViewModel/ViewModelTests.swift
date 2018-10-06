//
//  ViewModelTests.swift
//  testing_the_waters_of_iosTests
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest
@testable import testing_the_waters_of_ios

class ViewModelTests: XCTestCase {
    
    func testCalculateButtonTapRequestsPointCalculation() {
        // Arrange
        let storyPointCalc = StoryPointsCalculatorFake(storyPoints: 3)
        let sut = ViewModel(storyPointCalc)
        
        // Act
        sut.calculateButtonTapped()
        
        // Assert
        XCTAssertTrue(storyPointCalc.requestedCalculation)
    }
    
    func testTheDefaultLabelCopy() {
        // Arrange
        let storyPointCalc = StoryPointsCalculatorFake(storyPoints: 3)
        let sut = ViewModel(storyPointCalc)
        var labelText = ""
        
        // Act
        sut.labelText { text in
            labelText = text
        }
        
        // Assert
        XCTAssertEqual(labelText, "Estimates are damn hard! Right? Let us do the math for you!")
    }
    
    func testTheLabelCopyAfterTheCalculationForZeroPoints() {
        // Arrange
        let storyPointCalc = StoryPointsCalculatorFake(storyPoints: 0)
        let sut = ViewModel(storyPointCalc)
        var labelText = ""
        
        sut.labelText { (text) in
            labelText = text
        }
        
        // Act
        sut.calculateButtonTapped()
        
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
        let sut = ViewModel(ErroringStoryPointsCalculator())
        var labelText = ""
        sut.labelText { (text) in
            labelText = text
        }
        
        // Act
        sut.calculateButtonTapped()
        
        // Assert
        XCTAssertEqual(labelText, "🤭 It turns out we underestimated the difficulty of calculating story points! Please try again!")
    }
}

// MARK: Helpers

private func assertTextIsCorrectForEasyStories(expectedPoints: Int, file: StaticString = #file, line: UInt = #line) {
    // Arrange
    let storyPointCalc = StoryPointsCalculatorFake(storyPoints: expectedPoints)
    let sut = ViewModel(storyPointCalc)
    var labelText = ""
    
    sut.labelText { (text) in
        labelText = text
    }
    
    // Act
    sut.calculateButtonTapped()
    
    XCTAssertEqual(labelText, "This story is a definite \(expectedPoints) pointer! I double checked!", file: file, line: line)
}

private func assertTextIsCorrectForBigStories(expectedPoints: Int, file: StaticString = #file, line: UInt = #line) {
    // Arrange
    let storyPointCalc = StoryPointsCalculatorFake(storyPoints: expectedPoints)
    let sut = ViewModel(storyPointCalc)
    var labelText = ""
    
    sut.labelText { (text) in
        labelText = text
    }
    
    // Act
    sut.calculateButtonTapped()
    
    XCTAssertEqual(labelText, "Wow! I think it's a \(expectedPoints)! Maybe we should break this down into more stories?", file: file, line: line)
}

class StoryPointsCalculatorFake: StoryPointsCalculatorProtocol {
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

class ErroringStoryPointsCalculator: StoryPointsCalculatorProtocol {
    func calculate(completion: @escaping (Int?, Error?) -> Void) {
        completion(nil, RandomNumberFetcher.genericError)
    }
}
