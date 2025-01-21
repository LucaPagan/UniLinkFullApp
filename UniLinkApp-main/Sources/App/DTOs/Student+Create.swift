//
//  Student+Create.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 06/12/24.
//

import Vapor

extension Student {
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
        var major: Major
        var enrolledAt: Date
    }
}

extension Student.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
