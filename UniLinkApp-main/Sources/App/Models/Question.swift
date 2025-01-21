import Fluent
import Foundation

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class Question: Model, @unchecked Sendable {
    static let schema = Question.FieldKeys.schemaName
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: Question.FieldKeys.title)
    var title: String
    
    @Field(key: Question.FieldKeys.body)
    var body: String
    
    @Parent(key: Question.FieldKeys.studentID)
    var student: Student
    
    @Enum(key: Question.FieldKeys.major)
    var major: Major
    
    @Children(for: \.$question)
    var answers: [Answer]
    
    @Timestamp(key: Question.FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Question.FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: Question.FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?

    init() { }

    init(
        id: UUID? = nil,
        title: String,
        body: String,
        studentID: Student.IDValue,
        major: Major
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.$student.id = studentID
        self.major = major
    }
    
    func toDTO() -> QuestionDTO {
        .init(
            id: self.id,
            title: self.$title.value,
            body: self.$body.value,
            studentID: self.$student.id,
            major: self.$major.value,
            createdAt: self.createdAt
        )
    }
}
