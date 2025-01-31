//
//  EvaluatedStudentEntity+CoreDataProperties.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//
//

import Foundation
import CoreData


extension EvaluatedStudentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EvaluatedStudentEntity> {
        return NSFetchRequest<EvaluatedStudentEntity>(entityName: "EvaluatedStudentEntity")
    }

    @NSManaged public var answerMatrix: [[Bool]]?
    @NSManaged public var dni: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var scoreValue: NSDecimalNumber?

    public var score: Double? {
        get {
            return scoreValue?.doubleValue
        }
        set {
            if let newValue = newValue {
                scoreValue = NSDecimalNumber(value: newValue)
            } else {
                scoreValue = nil
            }
        }
    }
}

extension EvaluatedStudentEntity : Identifiable {

}
