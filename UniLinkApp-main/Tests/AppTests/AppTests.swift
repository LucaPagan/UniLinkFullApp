@testable import App
import XCTVapor
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct AppTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()   
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp { app in
            try await app.test(.GET, "hello", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }
    
    @Test("Getting all the Questions")
    func getAllQuestions() async throws {
        let student = Student(
            name: "Test",
            password: "password",
            email: "test@example.com",
            major: .ingegneriaInformatica,
            enrolledAt: Date.distantPast
        )
        
        try await withApp { app in
            try await student.create(on: app.db)
            let studentID = try student.requireID()
            
            let sampleQuestions = [
                Question(title: "sample1", body: "sample_body1", studentID: studentID, major: .informatica),
                Question(title: "sample2", body: "sample_body2", studentID: studentID, major: .ingegneriaInformatica)
            ]
            try await sampleQuestions.create(on: app.db)
            
            try await app.test(.GET, "api/v1/questions", afterResponse: { res async throws in
                #expect(res.status == .ok)
                #expect(try res.content.decode([QuestionDTO].self) == sampleQuestions.map { $0.toDTO() })
            })
        }
    }
    
    @Test("Creating a Question")
    func createQuestions() async throws {
        let student = try Student(
            name: "Test",
            password: Bcrypt.hash("password"),
            email: "test@example.com",
            major: .ingegneriaInformatica,
            enrolledAt: Date.distantPast
        )
        
        try await withApp { app in
            let newDTO = QuestionDTO(
                id: nil,
                title: "test",
                body: "test_body",
                major: .informatica
            )
            
            // Student Authentication
            try await student.create(on: app.db)
            let studentID = try student.requireID()
            var studentToken: String = ""
            try await app.test(
                .POST,
                "api/v1/students/login",
                headers: [
                    "Authorization": "Basic \((student.email + ":" + "password").base64String())"
                ]
            ) { res async throws in
                let studentTokenDTO = try res.content.decode(StudentTokenDTO.self)
                #expect(studentTokenDTO.studentID == studentID)
                studentToken = try #require(studentTokenDTO.value)
            }
            
            try await app.test(
                .POST,
                "api/v1/questions",
                headers: [
                    "Authorization": "Bearer \(studentToken)"
                ]
            ) { req in
                try req.content.encode(newDTO)
            } afterResponse: { res async throws in
                #expect(res.status == .ok)
                let models = try await Question.query(on: app.db).all()
                #expect(models.map({ $0.toDTO().title }) == [newDTO.title])
                XCTAssertEqual(models.map { $0.toDTO() }, [newDTO])
            }
        }
    }
    
    @Test("Deleting a Question")
    func deleteQuestion() async throws {
        let student = try Student(
            name: "Test",
            password: Bcrypt.hash("password"),
            email: "test@example.com",
            major: .ingegneriaInformatica,
            enrolledAt: Date.distantPast
        )
        
        try await withApp { app in
            try await student.create(on: app.db)
            let studentID = try student.requireID()
            
            let testQuestions = [
                Question(title: "test1", body: "test_body1", studentID: studentID, major: .informatica),
                Question(title: "test2", body: "test_body2", studentID: studentID, major: .ingegneriaInformatica)
            ]
            
            try await testQuestions.create(on: app.db)
            
            // Student Authentication
            var studentToken: String = ""
            try await app.test(
                .POST,
                "api/v1/students/login",
                headers: [
                    "Authorization": "Basic \((student.email + ":" + "password").base64String())"
                ]
            ) { res async throws in
                let studentTokenDTO = try res.content.decode(StudentTokenDTO.self)
                #expect(studentTokenDTO.studentID == studentID)
                studentToken = try #require(studentTokenDTO.value)
            }
            
            try await app.test(
                .DELETE,
                "api/v1/questions/\(testQuestions[0].requireID())",
                headers: [
                    "Authorization": "Bearer \(studentToken)"
                ]
            ) { res async throws in
                #expect(res.status == .noContent)
                let model = try await Question.find(testQuestions[0].id, on: app.db)
                #expect(model == nil)
            }
        }
    }
    
    @Test("Student Authentication")
    func studentAuthentication() async throws {
        let studentCreate = Student.Create(
            name: "Test",
            email: "test@example.com",
            password: "password",
            confirmPassword: "password",
            major: .ingegneriaInformatica,
            enrolledAt: Date.distantPast
        )
        
        try await withApp { app in
            var studentID: UUID = UUID()
            var studentToken: String = ""
            
            try await app.test(.POST, "api/v1/students") { req async throws in
                try req.content.encode(studentCreate)
            } afterResponse: { res async throws in
                let studentDTO = try res.content.decode(StudentDTO.self)
                #expect(studentDTO.name == studentCreate.name)
                #expect(studentDTO.email == studentCreate.email)
                studentID = try #require(studentDTO.id)
            }
            
            try await app.test(
                .POST,
                "api/v1/students/login",
                headers: [
                    "Authorization": "Basic \((studentCreate.email + ":" + studentCreate.password).base64String())"
                ]
            ) { res async throws in
                let studentTokenDTO = try res.content.decode(StudentTokenDTO.self)
                #expect(studentTokenDTO.studentID == studentID)
                studentToken = try #require(studentTokenDTO.value)
            }
            
            try await app.test(
                .GET,
                "api/v1/students/me",
                headers: [
                    "Authorization": "Bearer \(studentToken)"
                ]
            ) { res async throws in
                let studentDTO = try res.content.decode(StudentDTO.self)
                #expect(studentDTO.name == studentCreate.name)
                #expect(studentDTO.email == studentCreate.email)
                #expect(studentDTO.id == studentID)
            }
        }
    }
}

extension QuestionDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.body == rhs.body
            && lhs.studentID == rhs.studentID
            && lhs.major == rhs.major
            //&& lhs.createdAt == rhs.createdAt
    }
}
