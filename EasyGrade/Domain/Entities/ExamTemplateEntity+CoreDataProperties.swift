//
//  ExamTemplateEntity+CoreDataProperties.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//
//

import Foundation
import CoreData


extension ExamTemplateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExamTemplateEntity> {
        return NSFetchRequest<ExamTemplateEntity>(entityName: "ExamTemplateEntity")
    }

    @NSManaged public var cancelledQuestions: [Bool]?
    @NSManaged public var correctAnswerMatrix: [[Bool]]?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var numberOfAnswersPerQuestion: Int16
    @NSManaged public var numberOfQuestions: Int16
    @NSManaged public var penaltyBlankAnswer: Double
    @NSManaged public var penaltyIncorrectAnswer: Double
    @NSManaged public var scoreCorrectAnswer: Double
    @NSManaged public var evaluatedStudents: Set<EvaluatedStudentEntity>
    @NSManaged public var students: Set<StudentEntity>

}

// MARK: Generated accessors for evaluatedStudents
extension ExamTemplateEntity {

    @objc(addEvaluatedStudentsObject:)
    @NSManaged public func addToEvaluatedStudents(_ value: EvaluatedStudentEntity)

    @objc(removeEvaluatedStudentsObject:)
    @NSManaged public func removeFromEvaluatedStudents(_ value: EvaluatedStudentEntity)

    @objc(addEvaluatedStudents:)
    @NSManaged public func addToEvaluatedStudents(_ values: NSSet)

    @objc(removeEvaluatedStudents:)
    @NSManaged public func removeFromEvaluatedStudents(_ values: NSSet)

}

// MARK: Generated accessors for students
extension ExamTemplateEntity {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: StudentEntity)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: StudentEntity)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

extension ExamTemplateEntity : Identifiable {

}
