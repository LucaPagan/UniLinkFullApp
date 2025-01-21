//
//  StudentTokenDTO.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 09/12/24.
//

import Fluent
import Vapor

struct StudentTokenDTO: Content {
    var id: UUID?
    var value: String?
    var studentID: Student.IDValue?
    
    func toModel() throws -> StudentToken {
        let model = StudentToken()
        
        model.id = self.id
        if let value = self.value {
            model.value = value
        }
        if let studentID = self.studentID {
            model.$student.id = studentID
        }
        return model
    }
}
