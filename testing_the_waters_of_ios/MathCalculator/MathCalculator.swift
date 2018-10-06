//
//  MathCalculator.swift
//  testing_the_waters_of_ios
//
//  Created by Kostas Kremizas on 06/10/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import Foundation

class MathCalculator {
    private var fibMemo = [Int: Int]()
    
    func fibonacci(_ n: Int) -> Int {
        if let knownFib = fibMemo[n] {
            return knownFib
        }
        
        let result = (n <= 1) ? Int(n) : fibonacci(n-1) + fibonacci(n-2)
        fibMemo[n] = result
        return result
    }
}
