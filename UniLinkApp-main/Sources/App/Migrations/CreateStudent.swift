//
//  CreateStudent.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 03/12/24.
//

import Fluent

struct CreateStudent: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let major = try await database.enum(Major.FieldKeys.enumName).read()
        try await database.schema(Student.FieldKeys.schemaName)
            .id()
            .field(Student.FieldKeys.name, .string, .required)
            .field(Student.FieldKeys.password, .string, .required)
            .field(Student.FieldKeys.email, .string, .required).unique(on: Student.FieldKeys.email)
            .field(Student.FieldKeys.major, major, .required)
            .field(Student.FieldKeys.enrolledAt, .datetime, .required)
            .field(Student.FieldKeys.links, .array(of: .string), .required)
            .field(Student.FieldKeys.createdAt, .datetime)
            .field(Student.FieldKeys.updatedAt, .datetime)
            .field(Student.FieldKeys.deletedAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(Student.FieldKeys.schemaName).delete()
    }
}

extension Student {
    enum FieldKeys {
        static let schemaName = "students"
        static let name = FieldKey(stringLiteral: "name")
        static let password = FieldKey(stringLiteral: "password")
        static let email = FieldKey(stringLiteral: "email")
        static let major = FieldKey(stringLiteral: "major")
        static let enrolledAt = FieldKey(stringLiteral: "enrolled_at")
        static let links = FieldKey(stringLiteral: "links")
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
        static let deletedAt = FieldKey(stringLiteral: "deleted_at")
    }
}
