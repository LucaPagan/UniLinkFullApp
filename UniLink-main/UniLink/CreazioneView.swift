//  CreazioneView

import SwiftUI
import Foundation

struct CreazioneView: View {
    @Environment(\.dismiss) var dismiss
    @State private var question: String = ""
    @State private var questionCorpe: String = ""
    @State private var major: CorsoDiStudio = .agraria
    let email: String
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // orm to enter the information
                Form {
                    Section("Question Title") {
                        TextField("Question Title", text: $question)
                    }
                    
                    Section("Question Corpe") {
                        TextField("Question Corpe", text: $questionCorpe)
                    }
                    
                    Section("Category") {
                        Picker("Major", selection: $major) {
                            ForEach(CorsoDiStudio.allCases) { major in
                                Label(major.rawValue, systemImage: major.imageName)
                                    .tag(major)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Make your question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        Task {
                            await postQuestion()
                        }
                        // Action used to save the question
                        print("Question Confirmed: \(question)")
                        dismiss() //Close the page after the confirm
                    }
                    .disabled(question.isEmpty || questionCorpe.isEmpty) // "Disabled if the fields are empty"
                }
            }
        }
    }
    private func postQuestion() async {
        guard let url = URL(string: "\(apiHostname)/questions") else {
            print("Invalid URL for posting question")
            return
        }

        //Prepare the date for the new question
        guard let uuid = UUID(uuidString: email) else {
            print("Invalid UUID string: \(email)")
            return
        }

        let newQuestion = QuestionDTO(
            title: question,
            body: questionCorpe,
            studentID: uuid,
            major: major // Use the selected category
        )
        
        // "Encode the question in JSON format"
        guard let questionData = try? JSONEncoder().encode(newQuestion) else {
            print("Failed to encode question data")
            return
        }

        //Configure the resource for the POST request
        let resource = Resource(
            url: url,
            method: .post(questionData), // Send data in POST
            modelType: String.self // "Assume that the server returns a string as a response"
        )

        // execte the HTTP request
        do {
            let response = try await HTTPClient.shared.load(resource, loggedIn: true)
            print("Question posted successfully: \(response)")
            dismiss() //Close the view after success
        } catch {
            print("Failed to post question: \(error.localizedDescription)")
        }
    }

}

#Preview {
    CreazioneView(email: "example@studenti.unina.it")
}
