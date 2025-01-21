//
//  CreateAnswer.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 04/12/24.
//

import Fluent

struct CreateAnswer: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Answer.FieldKeys.schemaName)
            .id()
            .field(Answer.FieldKeys.body, .string, .required)
            .field(
                Answer.FieldKeys.questionID, .uuid, .required,
                .references(Question.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .field(
                Answer.FieldKeys.studentID, .uuid, .required,
                .references(Student.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .field(Answer.FieldKeys.createdAt, .datetime)
            .field(Answer.FieldKeys.updatedAt, .datetime)
            .field(Answer.FieldKeys.deletedAt, .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Answer.FieldKeys.schemaName).delete()
    }
}

extension Answer {
    enum FieldKeys {
        static let schemaName = "answers"
        static let body = FieldKey(stringLiteral: "body")
        static let questionID = FieldKey(stringLiteral: "question_id")
        static let studentID = FieldKey(stringLiteral: "student_id")
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
        static let deletedAt = FieldKey(stringLiteral: "deleted_at")
    }
}
