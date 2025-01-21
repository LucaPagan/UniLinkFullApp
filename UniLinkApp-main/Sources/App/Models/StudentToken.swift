//
//  StudentToken.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 06/12/24.
//

import Fluent
import struct Foundation.UUID

final class StudentToken: Model, @unchecked Sendable {
    static let schema = StudentToken.FieldKeys.schemaName
    
    @ID
    var id: UUID?
    
    @Field(key: StudentToken.FieldKeys.value)
    var value: String
    
    @Parent(key: StudentToken.FieldKeys.studentID)
    var student: Student
    
    init() {}
    
    init(id: UUID? = nil, value: String, studentID: Student.IDValue) {
        self.id = id
        self.value = value
        self.$student.id = studentID
    }
    
    func toDTO() -> StudentTokenDTO {
        .init(
            id: self.id,
            value: self.$value.value,
            studentID: self.$student.id
        )
    }
}

extension StudentToken {
    static func generate(for student: Student) throws -> StudentToken {
        let random = [UInt8].random(count: 16).base64
        return try StudentToken(value: random, studentID: student.requireID())
    }
}

extension StudentToken: ModelTokenAuthenticatable {
    static let valueKey = \StudentToken.$value
    static let userKey = \StudentToken.$student
    
    var isValid: Bool {
        true
    }
}
