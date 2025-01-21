//ListOfQuestionPage

import SwiftUI
import CryptoKit

struct ListOfQuestionPage: View {
    let corsoDiStudio: CorsoDiStudio
    @State private var searchText: String = ""

    // Lista delle domande
    @State private var questions: [Question] = [
        Question(
            id: UUID(), questionTitle: "What is the derivative of x^2?",
            questionCorpe: "Can someone explain how to compute this?",
            instEmail: "user1@studenti.unina.it",
            answers: [
                Answer(
                    ansewerCorpe: "The derivative is 2x.", questionId: "1",
                    answerID: UUID(), instEmail: "user2@studenti.unina.it"),
                Answer(
                    ansewerCorpe: "Let me explain further...", questionId: "1", answerID: UUID(),
                    instEmail: "user3@studenti.unina.it"),
            ],
            date: Date(), // Oggi
            student: .init()
        ),
        Question(
            id: UUID(), questionTitle: "What is the integral of 1/x?",
            questionCorpe: "I need help understanding this concept.",
            instEmail: "user2@studenti.unina.it",
            answers: [
                Answer(
                    ansewerCorpe: "The integral is ln|x| + C.", questionId: "2", answerID: UUID(),
                    instEmail: "user4@studenti.unina.it")
            ],
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,  // Ieri
            student: .init()
        ),
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
            Text("Questions - \(corsoDiStudio.rawValue)")
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
                            Text(question.student.name ?? "Username")
                        }
                        VStack(alignment: .leading) {
                            Text(question.questionTitle)
                                .font(.title2)
                            Text(question.questionCorpe)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }  //END HS

                }  //END NL
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadQuestions()
            }
        }
    }

    private func loadQuestions() async {
        let resources = Resource(
            url: URL(
                string:
                    "\(apiHostname)/questions/major/\(corsoDiStudio.rawValue)")!,
            modelType: [QuestionDTO].self)
        do {
            let questionDTO = try await HTTPClient.shared.load(resources)
            self.questions = []
            for question in questionDTO {
                let studentResource = Resource(
                    url: URL(string: "\(apiHostname)/students/\(question.studentID)")!,
                    modelType: StudentDTO.self)
                let student = try await HTTPClient.shared.load(studentResource)
                
                self.questions.append(
                    Question(
                        id: question.id!,
                        questionTitle: question.title,
                        questionCorpe: question.body,
                        instEmail: question.studentID.uuidString,
                        answers: [],
                        date: question.createdAt!,
                        student: student
                    )
                )
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// Modelli
struct Answer {
    let ansewerCorpe: String
    let questionId: String
    let answerID: UUID
    let instEmail: String
}

struct Question: Identifiable {
    let id: UUID
    let questionTitle: String
    let questionCorpe: String
    let instEmail: String
    let answers: [Answer]
    let date: Date  // Nuovo campo
    let student: StudentDTO
}

#Preview {
    NavigationStack {
        ListOfQuestionPage(corsoDiStudio: .informatica)
    }
}
