//
//  RegexPatterns.swift
//  EasyGrade
//
//  Created by Pablo Castro on 27/1/25.
//

import Foundation

struct RegexPatterns {
    static let nameRegex: String = #"(?i)apellidos?\s*y?\s*nombre:\s*([\w\s]+)"#
    static let dniRegex: String = #"(?i)dni[:\s]*([\d\s]{8,9})\s*-?\s*([a-zA-Z])"#
    static let answersRegex: String = #"(?i)respuestas:\s*([A-Z,\-\s\.]+)"#
}
