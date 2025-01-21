//
//  AnswerDTO.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 04/12/24.
//

import Fluent
import Vapor

struct AnswerDTO: Content {
    var id: UUID?
    var body: String?
    var questionID: Question.IDValue?
    var studentID: Student.IDValue?
    var createdAt: Date?
    
    func toModel() -> Answer {
        let model = Answer()
        
        model.id = self.id
        if let body = self.body {
            model.body = body
        }
        if let questionID = self.questionID {
            model.$question.id = questionID
        }
        if let studentID = self.studentID {
            model.$student.id = studentID
        }
        if let createdAt = self.createdAt {
            model.createdAt = createdAt
        }
        return model
    }
}
