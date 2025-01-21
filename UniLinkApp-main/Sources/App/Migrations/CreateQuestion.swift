import Fluent

struct CreateQuestion: AsyncMigration {
    func prepare(on database: Database) async throws {
        let major = try await database.enum(Major.FieldKeys.enumName).read()
        try await database.schema(Question.FieldKeys.schemaName)
            .id()
            .field(Question.FieldKeys.title, .string, .required)
            .field(Question.FieldKeys.body, .string, .required)
            .field(
                Question.FieldKeys.studentID, .uuid, .required,
                .references(Student.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .field(Question.FieldKeys.major, major, .required)
            .field(Question.FieldKeys.createdAt, .datetime)
            .field(Question.FieldKeys.updatedAt, .datetime)
            .field(Question.FieldKeys.deletedAt, .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Question.FieldKeys.schemaName).delete()
    }
}

extension Question {
    enum FieldKeys {
        static let schemaName = "questions"
        static let title = FieldKey(stringLiteral: "title")
        static let body = FieldKey(stringLiteral: "body")
        static let studentID = FieldKey(stringLiteral: "student_id")
        static let major = FieldKey(stringLiteral: "major")
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
        static let deletedAt = FieldKey(stringLiteral: "deleted_at")
    }
}
