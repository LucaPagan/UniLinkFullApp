//
//  Student.swift
//  UniLink
//
//  Created by Luca Pagano on 10/12/24.
//

import Foundation

struct StudentCreate: Codable {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
        var major: CorsoDiStudio
        var enrolledAt: Date
}

struct StudentDTO: Codable {
    var id: UUID?
    var name: String?
    var email: String?
    var major: CorsoDiStudio?
    var enrolledAt: Date?
    var links: [String]?
}

struct StudentTokenDTO: Codable {
    var id: UUID?
    var value: String?
    var studentID: UUID?
}
