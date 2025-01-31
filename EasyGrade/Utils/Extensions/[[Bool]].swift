//
//  [[Bool]].swift
//  EasyGrade
//
//  Created by Pablo Castro on 31/1/25.
//

import Foundation

extension [[Bool]] {
    func toAnswerString() -> String {
        var result = ""
        for row in self {
            if let selectedIndex = row.firstIndex(of: true) {
                let answerCharacter = Character(UnicodeScalar(65 + selectedIndex)!)
                result.append(answerCharacter)
            } else {
                result.append("-")
            }
        }
        return result
    }
}
