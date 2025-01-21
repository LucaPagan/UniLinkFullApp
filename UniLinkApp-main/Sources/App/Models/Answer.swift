//
//  Answer.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 04/12/24.
//

import Fluent
import Foundation

final class Answer: Model, @unchecked Sendable {
    static let schema = Answer.FieldKeys.schemaName
    
    @ID
    var id: UUID?
    
    @Field(key: Answer.FieldKeys.body)
    var body: String
    
    @Parent(key: Answer.FieldKeys.questionID)
    var question: Question
    
    @Parent(key: Answer.FieldKeys.studentID)
    var student: Student
    
    @Timestamp(key: Answer.FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Answer.FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: Answer.FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?

    init() { }

    init(
        id: UUID? = nil,
        body: String,
        questionID: Question.IDValue,
        studentID: Student.IDValue
    ) {
        self.id = id
        self.body = body
        self.$question.id = questionID
        self.$student.id = studentID
    }
    
    func toDTO() -> AnswerDTO {
        .init(
            id: self.id,
            body: self.$body.value,
            questionID: self.$question.id,
            studentID: self.$student.id,
            createdAt: self.createdAt
        )
    }
}
