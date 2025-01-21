import Fluent
import Vapor

struct QuestionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let questions = routes.grouped("api", "v1", "questions")

        questions.get(use: self.index)
        questions.group(":questionID") { question in
            question.get(use: self.get)
            question.get("answers", use: self.answers)
        }
        questions.group("major", ":major") { major in
            major.get(use: self.major)
        }
        
        let tokenProtected = questions.grouped(
            StudentToken.authenticator(),
            Student.guardMiddleware()
        )
        tokenProtected.post(use: self.create)
        tokenProtected.group(":questionID") { question in
            question.post("answers", use: self.createAnswer)
            question.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [QuestionDTO] {
        try await Question.query(on: req.db).all().map { $0.toDTO() }
    }
    
    @Sendable
    func get(req: Request) async throws -> QuestionDTO {
        guard let question = try await Question.find(req.parameters.get("questionID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return question.toDTO()
    }

    @Sendable
    func major(req: Request) async throws -> [QuestionDTO] {
        guard let majorString = req.parameters.get("major") else {
            throw Abort(.badRequest)
        }
        
        guard let major = Major(rawValue: majorString) else {
            throw Abort(.badRequest)
        }
        
        return try await Question.query(on: req.db)
            .filter(\.$major == major)
            .all()
            .map { $0.toDTO() }
    }
    
    @Sendable
    func answers(req: Request) async throws -> [AnswerDTO] {
        guard let question = try await Question.find(req.parameters.get("questionID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return try await question.$answers.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> QuestionDTO {
        let question = try req.content.decode(QuestionDTO.self).toModel()
        
        question.$student.id = try req.auth.require(Student.self).requireID()

        try await question.save(on: req.db)
        return question.toDTO()
    }

    @Sendable
    func createAnswer(req: Request) async throws -> AnswerDTO {
        let answer = try req.content.decode(AnswerDTO.self).toModel()
        
        answer.$student.id = try req.auth.require(Student.self).requireID()
        answer.$question.id = UUID(uuidString: req.parameters.get("questionID")!)!

        try await answer.save(on: req.db)
        return answer.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let question = try await Question.find(req.parameters.get("questionID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard try question.$student.id == req.auth.require(Student.self).requireID() else {
            throw Abort(.unauthorized)
        }

        try await question.delete(on: req.db)
        return .noContent
    }
}
