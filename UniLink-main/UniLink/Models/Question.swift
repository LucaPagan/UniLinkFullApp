//
//  Question.swift
//  UniLink
//
//  Created by Luca Pagano on 10/12/24.
//

import Foundation

struct QuestionDTO: Codable {
    var id: UUID?
    var title: String
    var body: String
    var studentID: UUID
    var major: CorsoDiStudio
    var createdAt: Date?
}
