import Fluent
import Vapor

struct QuestionDTO: Content {
    var id: UUID?
    var title: String?
    var body: String?
    var studentID: Student.IDValue?
    var major: Major?
    var createdAt: Date?
    
    func toModel() -> Question {
        let model = Question()
        
        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        if let body = self.body {
            model.body = body
        }
        if let studentID = self.studentID {
            model.$student.id = studentID
        }
        if let major = self.major {
            model.major = major
        }
        if let createdAt = self.createdAt {
            model.createdAt = createdAt
        }
        return model
    }
}
