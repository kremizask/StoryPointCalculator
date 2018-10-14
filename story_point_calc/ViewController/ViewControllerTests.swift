//
//  ViewControllerTests.swift
//  story_point_calcTests
//
//  Created by Kostas Kremizas on 07/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import XCTest
@testable import story_point_calc

class ViewModelSpy: ViewModelProtocol {
    var calculateButtonTappedCalled = false
    
    func calculateButtonTapped() {
        calculateButtonTappedCalled = true
    }
    
    func labelText(updates: @escaping (String) -> Void) {
        updates("dummy text")
    }
    
    func isButtonEnabled(updates: @escaping (Bool) -> Void) {
        updates(false)
    }
    
    func isLoading(updates: @escaping (Bool) -> Void) {
        updates(true)
    }
}

class ViewControllerTests: XCTestCase {
    
    var sut: ViewController!
    var viewModel: ViewModelSpy!
    
    override func setUp() {
        super.setUp()
        
        viewModel = ViewModelSpy()
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController
        sut.configure(viewModel)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testTheBindingViewModel() {
        // Act
        sut.calculateButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModel.calculateButtonTappedCalled)
        XCTAssertEqual(sut.label.text, "dummy text")
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        XCTAssertFalse(sut.calculateButton.isEnabled)
    }
}
