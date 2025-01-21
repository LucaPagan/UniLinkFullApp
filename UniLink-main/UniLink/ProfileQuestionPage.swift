//PorfileQuestionPage

import SwiftUI
import CryptoKit

struct ProfileQuestionPage: View {
    @State private var searchText: String = ""
    @State var studentID: UUID
    @State var questionDTO: [QuestionDTO]?  // L'array è opzionale

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
            date: Date(), // today
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
    var filteredQuestions: [QuestionDTO] {
        guard let questionDTOs = questionDTO else { return [] }  // Se questionDTO è nil, ritorna un array vuoto
        if searchText.isEmpty {
            return questionDTOs
        } else {
            return questionDTOs.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            // Titolo della pagina
            Text("Your questions")
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
            if let questions = questionDTO, !questions.isEmpty {
                List(questions, id: \.id) { questionDTO in
                    NavigationLink(destination: QuestionPage(
                        questionID: (questionDTO.id ?? UUID(uuidString: "7D663D38-B299-43AE-8C39-AFAD3F10BF3A"))!
                    )) {
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

                            VStack(alignment: .leading) {
                                Text(questionDTO.title)
                                    .font(.title2)
                                Text(questionDTO.body)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            } else {
                Text("No questions available")  // Messaggio nel caso l'array sia vuoto o nil
                    .foregroundColor(.gray)
            }
        }
        .task {
            await loadQuestions()  // Carica tutte le domande per lo studente
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadQuestions() async {
        let resources = Resource(
            url: URL(string: "\(apiHostname)/students/\(studentID)/questions")!,
            modelType: [QuestionDTO].self  // Restituisce un array di QuestionDTO
        )
        do {
            print("Requesting URL: \(String(describing: resources.url))")
            let loadedQuestions = try await HTTPClient.shared.load(resources)
            self.questionDTO = loadedQuestions  // Assegna l'array di domande a questionDTO
        } catch {
            print("Error loading questions: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        ProfileQuestionPage(studentID: UUID(uuidString: "D997B22D-B404-48B1-BBF9-77ACC926EB25")!)
    }
}
