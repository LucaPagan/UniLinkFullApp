//
//  CreateStudentToken.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 06/12/24.
//

import Fluent

struct CreateStudentToken: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(StudentToken.FieldKeys.schemaName)
            .id()
            .field(StudentToken.FieldKeys.value, .string, .required)
            .field(
                StudentToken.FieldKeys.studentID, .uuid, .required,
                .references(Student.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(StudentToken.FieldKeys.schemaName).delete()
    }
}

extension StudentToken {
    enum FieldKeys {
        static let schemaName = "student_tokens"
        static let value = FieldKey("value")
        static let studentID = FieldKey("student_id")
    }
}
