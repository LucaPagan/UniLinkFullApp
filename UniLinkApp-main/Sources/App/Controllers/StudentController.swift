//
//  StudentController.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 06/12/24.
//

import Fluent
import Vapor

struct StudentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let students = routes.grouped("api", "v1", "students")
        students.post(use: self.create)

        students.group(":studentID") { student in
            student.get(use: self.get)
            student.get("questions", use: self.questions)
            student.get("answers", use: self.answers)
        }
        
        let passwordProtected = students.grouped(Student.authenticator())
        passwordProtected.post("login", use: self.login)
        
        let tokenProtected = students.grouped(
            StudentToken.authenticator(),
            Student.guardMiddleware()
        )
        tokenProtected.get("me") { req -> StudentDTO in
            try req.auth.require(Student.self).toDTO()
        }
    }

    @Sendable
    func get(req: Request) async throws -> StudentDTO {
        guard let student = try await Student.find(req.parameters.get("studentID"), on: req.db) else {
            throw Abort(.notFound)
        }

        return student.toDTO()
    }

    @Sendable
    func questions(req: Request) async throws -> [QuestionDTO] {
        guard let student = try await Student.find(req.parameters.get("studentID"), on: req.db) else {
            throw Abort(.notFound)
        }

        return try await student.$questions.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func answers(req: Request) async throws -> [AnswerDTO] {
        guard let student = try await Student.find(req.parameters.get("studentID"), on: req.db) else {
            throw Abort(.notFound)
        }

        return try await student.$answers.query(on: req.db).all().map { $0.toDTO() }
    }
    
    @Sendable
    func create(req: Request) async throws -> StudentDTO {
        try Student.Create.validate(content: req)
        let create = try req.content.decode(Student.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let student = try Student(
            name: create.name,
            password: Bcrypt.hash(create.password),
            email: create.email,
            major: create.major,
            enrolledAt: create.enrolledAt
        )
        try await student.save(on: req.db)
        return student.toDTO()
    }
    
    @Sendable
    func login(req: Request) async throws -> StudentTokenDTO {
        let student = try req.auth.require(Student.self)
        let token = try student.generateToken()
        try await token.save(on: req.db)
        return token.toDTO()
    }
}
