//
//  StoryPointsCalculator.swift
//  testing_the_waters_of_ios
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation

protocol StoryPointsCalculatorProtocol {
    func calculate(completion: @escaping (Int?, Error?) -> Void)
}

class StoryPointsCalculator: StoryPointsCalculatorProtocol {
    private let randomFetcher: RandomNumberFetcherProtocol
    
    init(_ randomFetcher: RandomNumberFetcherProtocol) {
        self.randomFetcher = randomFetcher
    }
    
    func calculate(completion: @escaping (Int?, Error?) -> Void) {
        randomFetcher.fetchRandomNumber { (randomNumber, error) in
            completion(randomNumber.map(MathCalculator().fibonacci), error)
        }
    }
}
