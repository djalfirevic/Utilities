//
//  Solution.swift
//  Romans
//
//  Created by Djuro on 10/16/20.
//

import Foundation

final class Solution {
    
    // MARK: - Properties
    private let romanPrimeNumbers = [
        1: "I",
        4: "IV",
        5: "V",
        9: "IX",
        10: "X",
        40: "XL",
        50: "L",
        90: "XC",
        100: "C",
        400: "DC",
        500: "D",
        900: "CM",
        1000: "M",
    ]
    
    // MARK: - Public API
    func solve(_ number: Int) -> String {
        var numberToSolve = number
        var result = ""
        
        while numberToSolve > 0 {
            if let number = biggestPrimeNumber(from: numberToSolve) {
                numberToSolve -= number
                if let value = romanPrimeNumbers[number] {
                    result += value
                }
            }
        }
        
        return result
    }
    
    func biggestPrimeNumber(from number: Int) -> Int? {
        let keys = romanPrimeNumbers.keys.sorted(by: { $0 > $1 })
        
        for key in keys {
            if number - key >= 0 {
                return key
            }
        }
        
        return nil
    }
    
}
