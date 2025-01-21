//
//  Answer.swift
//  UniLink
//
//  Created by Luca Pagano on 10/12/24.
//

import Foundation

struct AnswerDTO: Codable, Identifiable {
    var id: UUID?
    var body: String?
    var questionID: UUID?
    var studentID: UUID?
    var createdAt: Date?
}
