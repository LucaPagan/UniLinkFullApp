//
//  StudentDTO.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 03/12/24.
//

import Fluent
import Vapor

struct StudentDTO: Content {
    var id: UUID?
    var name: String?
    var email: String?
    var major: Major?
    var enrolledAt: Date?
    var links: [String]?
    
    func toModel() -> Student {
        let model = Student()
        
        model.id = self.id
        if let name = self.name {
            model.name = name
        }
        if let email = self.email {
            model.email = email
        }
        if let major = self.major {
            model.major = major
        }
        if let enrolledAt = self.enrolledAt {
            model.enrolledAt = enrolledAt
        }
        if let links = self.links {
            model.links = links
        }
        return model
    }
}
