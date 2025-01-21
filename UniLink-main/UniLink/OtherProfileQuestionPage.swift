//  OtherProfileQuestionPage.swift

import SwiftUI
import CryptoKit

struct OtherProfileQuestionPage: View {
    @State private var searchText: String = ""

    // List of question
    let questions: [Question] = [
        Question(
            id: UUID(), questionTitle: "What is the purpose of an API?",
            questionCorpe: "Can someone explain how APIs are used in software development?",
            instEmail: "user1@studenti.unina.it",
            answers: [
                Answer(ansewerCorpe: "An API allows different software systems to communicate with each other.", questionId: "1", answerID: UUID(), instEmail: "user2@studenti.unina.it"),
                Answer(ansewerCorpe: "For example, a weather app might use an API to fetch weather data.", questionId: "1", answerID: UUID(), instEmail: "user3@studenti.unina.it")
            ],
            date: Date(), // Oggi
            student: .init()
        ),
        Question(
            id: UUID(), questionTitle: "How does a database index work?",
            questionCorpe: "I need help understanding how indexing speeds up queries.",
            instEmail: "user2@studenti.unina.it",
            answers: [
                Answer(ansewerCorpe: "Indexes create a data structure to make lookups faster, like a book's index.", questionId: "2", answerID: UUID(), instEmail: "user4@studenti.unina.it"),
                Answer(ansewerCorpe: "However, they come at the cost of extra storage and slower writes.", questionId: "2", answerID: UUID(), instEmail: "user5@studenti.unina.it")
            ],
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, // Ieri
            student: .init()
        )
    ]

    // Filtro per la ricerca
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
            // Titolo della pagina
            Text("Questions")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)

            // Barra di ricerca
            TextField("Search questions...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            // Lista delle domande
    
            List(filteredQuestions) { question in
                
                    NavigationLink(destination: QuestionPage(questionID: question.id)){
                        
                        VStack(alignment: .leading){
                            HStack{
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
                        VStack(alignment: .leading){
                            Text(question.questionTitle)
                                .font(.title2)
                            Text(question.questionCorpe)
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                        }//END HS
                        
                    }//END NL
            }
        }

        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OtherProfileQuestionPage()
    }
}
