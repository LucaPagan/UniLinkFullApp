//HomePage.swift

import Foundation
import SwiftUI
import CryptoKit

struct HomePage: View {
    @State private var showingCreazione = false  // Toggle for creation view
    @State private var selectedCategory: String? = nil  // Track selected category
    @State private var corso: CorsoDiStudio = .informatica  // User's major (can be dynamic)

    // Sample questions with answers
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
            date: Date(),  // Today's date
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
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,  // Yesterday
            student: .init()
        ),
    ]
    let email: String

    // Function to get most recent questions
    @State private var recentQuestions: [Question] = []

    var body: some View {
        NavigationStack {
            VStack {
                // Header with UniLink title and profile icon
                HStack {
                    Text("UniLink")
                        .font(.largeTitle)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()

                    NavigationLink(destination: ProfilePage(userEmail: email)) {
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                            .padding()
                    }
                }

                // Horizontal scroll for categories

                HStack(spacing: 16) {  // Imposta lo spazio tra i bottoni
                    // Button for the student's major
                    NavigationLink(
                        destination: ListOfQuestionPage(corsoDiStudio: corso)
                    ) {
                        VStack {
                            Image(systemName: corso.imageName)
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(corso.rawValue)
                                .font(.system(size: 18))
                        }
                        .padding()
                        .frame(width: 200, height: 100)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

                    // Button for general questions
                    NavigationLink(
                        destination: ListOfQuestionPage(
                            corsoDiStudio: CorsoDiStudio.faq)
                    ) {
                        VStack {
                            Image(systemName: CorsoDiStudio.faq.imageName)
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(CorsoDiStudio.faq.rawValue)
                                .font(.system(size: 18))
                        }
                        .frame(width: 120, height: 100)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()

                // Link to All Sections page
                NavigationLink(destination: AllSectionPage()) {
                    Text("All Section")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                .padding(.top, 5)
                .padding(.bottom, 20)

                List {
                    Section(
                        header: Text(corso.rawValue + " Questions").font(
                            .headline)
                        .padding()
                    ) {
                        ForEach(recentQuestions) { question in
                            NavigationLink(
                                destination: QuestionPage(
                                    questionID: question.id)
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
                                            .frame(width: 20, height: 20)
                                            .aspectRatio(contentMode: .fill)
                                        Text("Username")  // Placeholder per username
                                    }
                                    VStack(alignment: .leading) {
                                        Text(question.questionTitle)
                                            .font(.title3)
                                        Text(question.questionCorpe)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.automatic)
                
                
            }
            .navigationTitle("UniLink")
            .navigationBarHidden(true)
            .toolbar {
                // Bottom toolbar for adding new content
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            showingCreazione.toggle()  // Toggle the creation view
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .frame(alignment: .center)
                        }
                        .sheet(isPresented: $showingCreazione) {
                            NavigationStack {
                                CreazioneView(email: email)
                                    .presentationDetents([.fraction(0.68)])
                            }
                        }
                    }
                }
            }
            .task {
                await loadQuestions()
            }
        }
    }
    
    private func loadQuestions() async {
        let resources = Resource(
            url: URL(
                string:
                    "\(apiHostname)/questions/major/\(corso.rawValue)")!,
            modelType: [QuestionDTO].self)
        do {
            let questionDTO = try await HTTPClient.shared.load(resources)
            self.recentQuestions = []
            for question in questionDTO {
                let studentResource = Resource(
                    url: URL(string: "\(apiHostname)/students/\(question.studentID)")!,
                    modelType: StudentDTO.self)
                let student = try await HTTPClient.shared.load(studentResource)
                
                self.recentQuestions.append(
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

#Preview {
    HomePage(email: "D997B22D-B404-48B1-BBF9-77ACC926EB25")
}
