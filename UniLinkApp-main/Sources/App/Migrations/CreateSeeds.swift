//
//  CreateSeeds.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 10/12/24.
//

import Fluent
import Vapor

struct CreateSeeds: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let passwordHash = try Bcrypt.hash("password")
        let users: [Student] = [
            .init(
                name: "Francesco Paolo Severino",
                password: passwordHash,
                email: "fp.severino@studenti.unina.it",
                major: .ingegneriaInformatica,
                enrolledAt: Date.now
            ),
            .init(
                name: "Luca Pagano",
                password: passwordHash,
                email: "l.pagano@studenti.unina.it",
                major: .informatica,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "Riccardo Puggioni",
                password: passwordHash,
                email: "r.puggioni@studenti.unina.it",
                major: .informatica,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "Lorenzo Avagliano",
                password: passwordHash,
                email: "l.avagliano@studenti.unina.it",
                major: .medicina,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "Roberto Palumbo",
                password: passwordHash,
                email: "r.palumbo@studenti.unina.it",
                major: .lettereFilosofia,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "Roberta Napolitano",
                password: passwordHash,
                email: "r.napolitano.unina.it",
                major: .economia,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "Lorenzo Apicella",
                password: passwordHash,
                email: "l.apicella@studenti.unina.it",
                major: .economia,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "Francesca Cannavacciuolo",
                password: passwordHash,
                email: "f.cannavacciuolo.unina.it",
                major: .psicologia,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "Gaetano Sorbo",
                password: passwordHash,
                email: "g.sorbo.unina.it",
                major: .psicologia,
                enrolledAt: Date.distantPast
            ),
            .init(
                name: "christian Pastore",
                password: passwordHash,
                email: "c.pastore.unina.it",
                major: .medicina,
                enrolledAt: Date.distantPast
            ),
        ]
        try await users.create(on: database)
        
        let questions: [Question] = [
            .init(
                title: "How to create a new migration?",
                body: "I'm trying to create a new migration but I don't know how to do it. Can someone help me?",
                studentID: users[0].id!,
                major: .ingegneriaInformatica
            ),
            .init(
                title: "How to create a new model?",
                body: "I'm trying to create a new model but I don't know how to do it. Can someone help me?",
                studentID: users[1].id!,
                major: .informatica
            ),
            .init(
                title: "How to create a new controller?",
                body: "I'm trying to create a new controller but I don't know how to do it. Can someone help me?",
                studentID: users[2].id!,
                major: .informatica
            ),
            .init(
                title: "Urea CycleExplanation",
                body: "Could you explain to me properly the urea cycle?",
                studentID: users[3].id!,
                major: .medicina
            ),
            .init(
                title: "Need some help on Leopardi",
                body: "In what period did Leopardi's cosmic pessimism arise?",
                studentID: users[4].id!,
                major: .lettereFilosofia
            ),
            .init(
                title: "Income Statement and Balance Sheet Connection",
                body: "Can you explain to me what the connection is between the income statement and the balance sheet?",
                studentID: users[5].id!,
                major: .economia
            ),
            .init(
                title: "Internal Revenues",
                body: "What are internal revenues?",
                studentID: users[6].id!,
                major: .economia
            ),
            .init(
                title: "Mind and brain Interconnection",
                body: "I'm trying to understand the interconnection between the mind and the brain. Can someone help me?",
                studentID: users[7].id!,
                major: .psicologia
            ),
            .init(
                title: "Psychosis vs Schizophrenia",
                body: "Can Someone explain the difference between psychosis and schizophrenia?",
                studentID: users[8].id!,
                major: .psicologia
            ),
            .init(
                title: "RB protein",
                body: "How the mutation of the RB protein causes cancer?",
                studentID: users[9].id!,
                major: .medicina
            ),
            
        ]
        try await questions.create(on: database)
        let answers: [Answer] = [
            .init(
                body: "You have to create a new file in the `Sources/App/Migrations` directory.",
                questionID: questions[0].id!,
                studentID: users[1].id!
            ),
            .init(
                body: "You have to create a new file in the `Sources/App/Models` directory.",
                questionID: questions[1].id!,
                studentID: users[2].id!
            ),
            .init(
                body: "You have to create a new file in the `Sources/App/Controllers` directory.",
                questionID: questions[2].id!,
                studentID: users[0].id!
            ),
            .init(
                body: "The urea cycle is a series of biochemical reactions in the liver that converts toxic ammonia into urea, which is then excreted in urine. It helps detoxify the body and maintain nitrogen balance.",
                questionID: questions[3].id!,
                studentID: users[9].id!
            ),
            .init(
                body: "Leopardi's cosmic pessimism emerged during the early 19th century, particularly in the 1810s and 1820s.",
                questionID: questions[4].id!,
                studentID: users[0].id!
            ),
            .init(
                body: "The income statement shows a company's revenues and expenses over a specific period, resulting in a net income or loss. This statement reflects the company’s profitability. On the other hand, the balance sheet shows the company’s assets, liabilities, and shareholders' equity at a specific point in time, providing a snapshot of its financial position.",
                questionID: questions[5].id!,
                studentID: users[6].id!
            ),
            .init(
                body: "Internal revenues refer to income generated within an organization, often from internal transactions or sales between subsidiaries or departments",
                questionID: questions[6].id!,
                studentID: users[5].id!
            ),
            .init(
                body: "The mind and brain are interconnected; the brain is the physical organ that controls mental processes, while the mind refers to thoughts, emotions, and consciousness. Brain activity gives rise to mental experiences.",
                questionID: questions[7].id!,
                studentID: users[8].id!
            ),
            .init(
                body: "Exploratory factor analysis (EFA) is used to discover underlying structures in data without a predefined hypothesis, while confirmatory factor analysis (CFA) tests if a hypothesized factor structure fits the data.",
                questionID: questions[8].id!,
                studentID: users[7].id!
            ),
            .init(
                body: "Mutations in the RB protein disrupt its role in controlling cell division, leading to uncontrolled cell growth. This can contribute to cancer, particularly in the case of retinoblastoma and other tumors.",
                questionID: questions[9].id!,
                studentID: users[3].id!
            ),
        ]
        try await answers.create(on: database)
    }
    func revert(on database: any Database) async throws {
        try await Student.query(on: database).delete()
        try await Question.query(on: database).delete()
        try await Answer.query(on: database).delete()
    }
}
