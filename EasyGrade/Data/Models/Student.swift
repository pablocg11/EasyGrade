//
//  Student.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//

import Foundation

struct Student: Identifiable, Hashable {
    var id: UUID
    var dni: String
    var name: String
    
    init(id: UUID, dni: String, name: String) {
        self.id = id
        self.dni = dni
        self.name = name
    }
}
