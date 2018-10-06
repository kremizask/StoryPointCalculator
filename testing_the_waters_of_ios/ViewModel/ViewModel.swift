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
    private var labelText = "" {
        didSet {
            labelTextCallback?(labelText)
        }
    }
    
    private let initialLabelText = NSLocalizedString("Estimates are damn hard! Right? Let us do the math for you!", comment: "Default label text")
    private static let errorText = NSLocalizedString("🤭 It turns out we underestimated the difficulty of calculating story points! Please try again!", comment: "Error Text")
    
    public init(_ storyPointsCalculator: StoryPointsCalculatorProtocol) {
        self.storyPointsCalculator = storyPointsCalculator
    }
    
    func calculateButtonTapped() {
        storyPointsCalculator.calculate { [weak self] (number, error) in
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
    
    // MARK: Private
    
    private func labelText(forPoints points: Int) -> String {
        let smallStoriesText = String.localizedStringWithFormat("This story is a definite %d pointer! I double checked!", points)
        let bigStoriesText = String.localizedStringWithFormat("Wow! I think it's a %d! Maybe we should break this down into more stories?", points)
        return (points > 5) ? bigStoriesText : smallStoriesText
    }
}
