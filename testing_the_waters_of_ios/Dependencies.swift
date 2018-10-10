//
//  Dependencies.swift
//  story_point_calc
//
//  Created by Kostas Kremizas on 07/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation

struct Dependencies {
    private static func makeHttpClient() -> HttpClient {
        return URLSession.shared
    }
    
    private static func makeRandomNumberFetcher() -> RandomNumberFetcherProtocol {
        return RandomNumberFetcher(httpClient: makeHttpClient())
    }
    
    private static func makeStoryPointsCalculator() -> StoryPointsCalculatorProtocol {
        return StoryPointsCalculator(makeRandomNumberFetcher())
    }
    
    static func makeViewModel() -> ViewModelProtocol {
        return ViewModel(makeStoryPointsCalculator())
    }
}
