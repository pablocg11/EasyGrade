//
//  RegexPatterns.swift
//  EasyGrade
//
//  Created by Pablo Castro on 27/1/25.
//

import Foundation

final class RegexPatterns {
    static let nameRegex: String = #"(?i)^(?:apellidos y nombre|nombre y apellidos):\s*(.+)$"#
    static let dniRegex: String = #"(?i)^dni:\s*([0-9]{1,3}(?:[.\s]?[0-9]{3})*\s*-?\s*[a-zA-Z])$"#
    static let answersRegex: String = #"(?i)^respuestas:\s*([A-Z\s\-]+)$"#
}
