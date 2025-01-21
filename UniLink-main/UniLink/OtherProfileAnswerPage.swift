//  OtherProfileAnswerPage.swift

import CryptoKit
import SwiftUI

struct OtherProfileAnswerPage: View {
    @State private var searchText: String = ""

    // List of question
    let questions: [Question] = [
        Question(
            id: UUID(), questionTitle: "What is the derivative of x^2?",
            questionCorpe: "Can someone explain how to compute this?",
            instEmail: "user1@studenti.unina.it",
            answers: [
                Answer(
                    ansewerCorpe: "The derivative is 2x.", questionId: "1",
                    answerID: UUID(), instEmail: "user2@studenti.unina.it"),
                Answer(
                    ansewerCorpe: "Let me explain further...", questionId: "1",
                    answerID: UUID(), instEmail: "user3@studenti.unina.it"),
            ],
            date: Date(),  // today
            student: .init()
        ),
        Question(
            id: UUID(), questionTitle: "What is the integral of 1/x?",
            questionCorpe: "I need help understanding this concept.",
            instEmail: "user2@studenti.unina.it",
            answers: [
                Answer(
                    ansewerCorpe: "The integral is ln|x| + C.", questionId: "2",
                    answerID: UUID(), instEmail: "user4@studenti.unina.it")
            ],
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,  // yesterday
            student: .init()
        ),
    ]

    // filter research
    var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return questions
        } else {
            return questions.filter {
                $0.questionTitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            // TittlePage
            Text("Answers")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)

            // SearchBar
            TextField("Search questions...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            // List of Q & A
            List {
                ForEach(filteredQuestions, id: \.questionTitle) { question in
                    ForEach(question.answers, id: \.answerID) { answer in
                        NavigationLink(
                            destination: QuestionPage(questionID: question.id)
                        ) {
                            VStack(alignment: .leading) {
                                HStack {
                                    AsyncImage(
                                        url: URL(
                                            string:
                                                "https://www.gravatar.com/avatar/\(SHA256.hash(data: Data("CAMBIARE CON EMAIL \(UUID().uuidString)".utf8)).map { "0\(String($0, radix: 16))".suffix(2) }.joined())?s=200&d=monsterid"
                                        )
                                    ) { image in
                                        image
                                            .resizable()
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 40, height: 40)
                                    .aspectRatio(contentMode: .fill)
                                    Text("Username")
                                }

                                VStack(alignment: .leading, spacing: 5) {
                                    // user's answer
                                    Text(answer.ansewerCorpe)
                                        .font(.body)
                                        .bold()

                                    //"Related question"
                                    Text(question.questionTitle)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OtherProfileAnswerPage()
    }
}
