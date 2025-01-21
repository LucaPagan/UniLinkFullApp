//  QuestionPage.swift

import SwiftUI
import CryptoKit

struct QuestionPage: View {
    let questionID: UUID
    @State private var question: Question?
    @State private var isLoading: Bool = true
    @State private var isShowingAddAnswerSheet = false
    @State private var answers: [AnswerDTO] = []
    @State private var student: StudentDTO?
    let date = Date()

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let question = question {
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(
                            url: URL(
                                string:
                                    "https://www.gravatar.com/avatar/\(SHA256.hash(data: Data((student?.email ?? "").utf8)).map { "0\(String($0, radix: 16))".suffix(2) }.joined())?s=200&d=monsterid"
                            )
                        ) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fill)
                        Text(student?.name ?? "User")
                    }
                    .padding(.horizontal)

                    VStack {
                        Text(question.questionTitle)
                            .font(.title)
                            .bold()
                            .padding(.horizontal)
                        Text(question.questionCorpe)
                            .padding()
                    }

                    List {
                        Section {
                            ForEach(answers) { answer in
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
                                            .frame(width: 30, height: 30)
                                            .aspectRatio(contentMode: .fill)
                                        Text("Username")
                                    }
                                    Text(answer.body ?? "")
                                }
                            }
                        } header: {
                            HStack {
                                Spacer()
                                Text("Answers")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                    .refreshable {
                        await loadAnswers()
                    }

                    // Bottone per aggiungere una risposta
                    Button(action: {
                        isShowingAddAnswerSheet = true
                    }) {
                        Text("Add Answer")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            } else {
                Text("Question not found.")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Question Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingAddAnswerSheet) {
            if let question = question {
                AddAnswerSheet(
                    answers: .constant(question.answers),
                    questionID: question.id.uuidString,
                    userEmail: "user@example.com"
                )
                .presentationDetents([.fraction(0.70)])
                .presentationDragIndicator(.visible)
            }
        }
        .task {
            await loadQuestion()
            await loadAnswers()
            await loadStudent()
        }
    }

    private func loadQuestion() async {
        let resources = Resource(
            url: URL(string: "\(apiHostname)/questions/\(questionID)")!,
            modelType: QuestionDTO.self)
        do {
            let questionDTO = try await HTTPClient.shared.load(resources)
            self.question = .init(
                id: questionDTO.id!,
                questionTitle: questionDTO.title,
                questionCorpe: questionDTO.body,
                instEmail: questionDTO.studentID.uuidString,
                answers: [],
                date: questionDTO.createdAt!,
                student: .init()
            )
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
        }
    }

    private func loadAnswers() async {
        let resources = Resource(
            url: URL(string: "\(apiHostname)/questions/\(questionID)/answers")!,
            modelType: [AnswerDTO].self)
        do {
            self.answers = try await HTTPClient.shared.load(resources)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func loadStudent() async {
        try? await Task.sleep(for: .milliseconds(300))
        if let question {
            let resources = Resource(
                url: URL(
                    string: "\(apiHostname)/students/\(question.instEmail)")!,
                modelType: StudentDTO.self)
            do {
                self.student = try await HTTPClient.shared.load(resources)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuestionPage(
            questionID: UUID(
                uuidString: "7D663D38-B299-43AE-8C39-AFAD3F10BF3A")!
        )
    }
}
