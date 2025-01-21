//
//  AddAnswerSheet.swift
//  UniLink
//
//  Created by Luca Pagano on 08/12/24.
//

import SwiftUI

struct AddAnswerSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var answers: [Answer]
    let questionID: String

    // Simulazione di un utente autenticato
    let userEmail: String

    @State private var answerBody = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Answer")) {
                    ZStack(alignment: .topLeading) {
                        if answerBody.isEmpty {
                            Text("Write your answer...")
                                .foregroundColor(.gray)
                                .padding(.top)
                                .padding(.leading, 10)
                                .font(.subheadline)
                        }

                        TextEditor(text: $answerBody)
                            .frame(height: 150)
                            .padding(4)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            
            }
            .navigationTitle("Add Answer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        if !answerBody.isEmpty {
                            Task { await postAnswer() }
                            dismiss()
                        }
                    }
                    .disabled(answerBody.isEmpty)
                }
            }
        }
    }
    
    private func postAnswer() async {
        let answerDTO = AnswerDTO(body: answerBody)
        let answerDTOData = try? JSONEncoder().encode(answerDTO)
        let resource = Resource(url: URL(string: "\(apiHostname)/questions/\(questionID)/answers")!, method: .post(answerDTOData), modelType: String.self)
        let response = try? await HTTPClient.shared.load(resource, loggedIn: true)
        if let response {
            print(response)
        }
    }
}

// Anteprima della vista
#Preview {
    AddAnswerSheet(answers: .constant([]), questionID: "", userEmail: "user4@studenti.unina.it")
}
