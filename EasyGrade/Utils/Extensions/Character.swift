//
//  Character.swift
//  EasyGrade
//
//  Created by Pablo Castro on 31/1/25.
//

import Foundation

extension Character {
    func asAnswerIndex() -> Int? {
        guard let asciiValue = self.asciiValue, asciiValue >= 65, asciiValue <= 90 else {
            return nil
        }
        let index = Int(asciiValue - 65)
        return index
    }
}
