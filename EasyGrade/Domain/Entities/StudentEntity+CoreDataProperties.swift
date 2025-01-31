//
//  StudentEntity+CoreDataProperties.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//
//

import Foundation
import CoreData


extension StudentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentEntity> {
        return NSFetchRequest<StudentEntity>(entityName: "StudentEntity")
    }

    @NSManaged public var dni: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension StudentEntity : Identifiable {

}
