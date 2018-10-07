//
//  ViewModel.swift
//  testing_the_waters_of_ios
//
//  Created by Kostas Kremizas on 07/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation

class ViewModel {
    
    private let storyPointsCalculator: StoryPointsCalculatorProtocol
    private var labelTextCallback: ((String) -> Void)?
    private var isButtonEnabledCallback: ((Bool) -> Void)?
    private var isLoadingCallback: ((Bool) -> Void)?
    private var isLoading = false {
        didSet {
            dispatchQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.isButtonEnabledCallback?(!strongSelf.isLoading)
                strongSelf.isLoadingCallback?(strongSelf.isLoading)
            }
        }
    }
    
    private var labelText = "" {
        didSet {
            dispatchQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.labelTextCallback?(strongSelf.labelText)
            }
        }
    }
    
    private let initialLabelText = NSLocalizedString("Estimates are damn hard! Right? Let us do the math for you!", comment: "Default label text")
    private static let errorText = NSLocalizedString("🤭 It turns out we underestimated the difficulty of calculating story points! Please try again!", comment: "Error Text")
    private let dispatchQueue: DispatchQueue
    
    public init(_ storyPointsCalculator: StoryPointsCalculatorProtocol, _ dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.storyPointsCalculator = storyPointsCalculator
        self.dispatchQueue = dispatchQueue
    }
    
    func calculateButtonTapped() {
        isLoading = true
        
        storyPointsCalculator.calculate { [weak self] (number, error) in
            defer {
                self?.isLoading = false
            }
            
            guard
                let number = number,
                let strongSelf = self,
                error == nil else {
                    
                self?.labelText = ViewModel.errorText
                return
            }
            
            strongSelf.labelText = strongSelf.labelText(forPoints: number)
        }
    }
    
    func labelText(updates: @escaping (String) -> Void) {
        labelTextCallback = updates
        
        // Trigger callback with
        self.labelText = initialLabelText
    }
    
    func isButtonEnabled(updates: @escaping (Bool) -> Void) {
        isButtonEnabledCallback = updates
        // initially the button is enabled
        updates(true)
    }
    
    func isLoading(updates: @escaping (Bool) -> Void) {
        isLoadingCallback = updates
        // initially not calculating
        updates(false)
    }
    
    // MARK: Private
    
    private func labelText(forPoints points: Int) -> String {
        let zeroPointsText = NSLocalizedString("Done! What's next?", comment: "Zero points text")
        let smallStoriesText = String.localizedStringWithFormat("This story is a definite %d pointer! I double checked!", points)
        let bigStoriesText = String.localizedStringWithFormat("Wow! I think it's a %d! Maybe we should break this down into more stories?", points)
        
        switch points {
        case (...0):
            return zeroPointsText
        case (1...5):
            return smallStoriesText
        default:
            return bigStoriesText
        }
    }
}
