//
//  Student.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 03/12/24.
//

import Fluent
import Foundation
import Vapor

final class Student: Model, @unchecked Sendable {
    static let schema = Student.FieldKeys.schemaName
    
    @ID
    var id: UUID?
    
    @Field(key: Student.FieldKeys.name)
    var name: String
    
    @Field(key: Student.FieldKeys.password)
    var password: String
    
    @Field(key: Student.FieldKeys.email)
    var email: String
    
    @Enum(key: Student.FieldKeys.major)
    var major: Major
    
    @Field(key: Student.FieldKeys.enrolledAt)
    var enrolledAt: Date
    
    @Field(key: Student.FieldKeys.links)
    var links: [String]
    
    @Children(for: \.$student)
    var questions: [Question]
    
    @Children(for: \.$student)
    var answers: [Answer]
    
    @Timestamp(key: Student.FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Student.FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: Student.FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        name: String,
        password: String,
        email: String,
        major: Major,
        enrolledAt: Date,
        links: [String] = []
    ) {
        self.id = id
        self.name = name
        self.password = password
        self.email = email
        self.major = major
        self.enrolledAt = enrolledAt
        self.links = links
    }
    
    func toDTO() -> StudentDTO {
        .init(
            id: self.id,
            name: self.$name.value,
            email: self.$email.value,
            major: self.$major.value,
            enrolledAt: self.$enrolledAt.value
        )
    }
}

extension Student: ModelAuthenticatable {
    static let usernameKey = \Student.$email
    static let passwordHashKey = \Student.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension Student {
    func generateToken() throws -> StudentToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            studentID: self.requireID()
        )
    }
}
