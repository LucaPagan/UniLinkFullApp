//ProfilePage.swift

import SwiftUI
import CryptoKit

struct ProfilePage: View {
    @State private var userName: String = "John Appleseed"
    let userEmail: String
    @State private var userMajor: String = "Computer Engineering"
    @State private var userYear: String = "First"
    @State private var profileImageURL: URL? = URL(
        string: "https://www.gravatar.com/avatar/fefvwsv?s=200&d=mp")
    @State private var isEditing: Bool = false
    @State private var student: StudentDTO?

    // link
    @State private var customLinks: [String] = [
        "https://www.linkedin.com/in/name--33b70430b/",  // Use string interpolation
        "https://www.github.com/example",
    ]
    @State private var newLinkURL: String = ""
    @State private var showError: Bool = false

    // Variabile userDate (anno di immatricolazione)
    @State private var userDate: Date =
        Calendar.current.date(
            from: DateComponents(year: 2023, month: 9, day: 1)) ?? Date()

    // FocusState per il controllo del campo di testo
    @FocusState private var isLinkFieldFocused: Bool

    var body: some View {
        VStack {
            // Header con immagine e informazioni base
            VStack(spacing: 10) {
                AsyncImage(
                    url: URL(
                        string:
                            "https://www.gravatar.com/avatar/\(SHA256.hash(data: Data("CAMBIARE CON EMAIL \(UUID().uuidString)".utf8)).map { "0\(String($0, radix: 16))".suffix(2) }.joined())?s=200&d=monsterid"
                    )
                ) { image in
                    image
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                }

                Text(student?.name ?? userName)
                    .font(.title)
                    .bold()

                Text(student?.email ?? userEmail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("YOUR INFO")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    Label("Major", systemImage: "desktopcomputer")
                        .font(.body)
                    Spacer()
                    Text(student?.major?.rawValue ?? userMajor)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.blue.opacity(0.2)))
                }
                Divider()

                HStack {
                    Label("Year", systemImage: "books.vertical")
                        .font(.body)
                    Spacer()
                    Text(userYear)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.blue.opacity(0.2)))
                }
                Divider()

                Text("YOUR LINKS")
                    .font(.caption)
                    .foregroundColor(.gray)

                // Collegamenti
                if isEditing {
                    ForEach(Array(customLinks.enumerated()), id: \.offset) {
                        index, link in
                        HStack {
                            TextField("Link", text: $customLinks[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                customLinks.remove(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 5)

                    // Aggiungi nuovo link
                    HStack {
                        TextField("New URL", text: $newLinkURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isLinkFieldFocused)  // Monitora il focus del campo
                            .onSubmit {
                                validateLink()
                            }

                        Button(action: {
                            validateLink()
                            if !showError {
                                customLinks.append(newLinkURL)
                                newLinkURL = ""
                            }
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(
                                    isValidURL(newLinkURL) ? .blue : .gray)
                        }
                        .disabled(!isValidURL(newLinkURL))
                    }
                    .padding(.vertical, 5)

                    // Messaggio di errore
                    if showError {
                        Text(
                            "Please enter a valid URL starting with http:// or https://"
                        )
                        .foregroundColor(.red)
                        .font(.footnote)
                    }
                } else {
                    ForEach(customLinks, id: \.self) { link in
                        HStack {
                            Text(link)
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 8).stroke(
                                Color.gray, lineWidth: 1))
                    }
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)

            // Bottoni di navigazione
            VStack(spacing: 1) {
                let studentID =
                    student?.id ?? UUID(
                        uuidString: "D997B22D-B404-48B1-BBF9-77ACC926EB25")!
                NavigationLink(
                    destination: ProfileQuestionPage(studentID: studentID)
                ) {
                    HStack {
                        Label("Questions", systemImage: "questionmark.circle")
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                Divider()

                NavigationLink(destination: ProfileAnswerPage()) {
                    HStack {
                        Label("Answers", systemImage: "info.circle")
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding()

            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                    updateYear()
                }
            }
        }
        .onAppear {
            updateYear()  // Calcola l'anno automaticamente quando la vista appare
        }
        .task {
            await loadStudent()
        }
    }
    
    private func loadStudent() async {
        let resources = Resource(
            url: URL(string: "\(apiHostname)/students/\(userEmail)")!,
            modelType: StudentDTO.self)
        do {
            self.student = try await HTTPClient.shared.load(resources)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Funzione per calcolare l'anno di università basato sulla data di immatricolazione
    func updateYear() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let enrollmentYear = Calendar.current.component(.year, from: userDate)

        // Calcoliamo la differenza tra l'anno corrente e l'anno di immatricolazione
        let yearDifference = currentYear - enrollmentYear

        // Assegniamo l'anno di università in base alla differenza
        if yearDifference == 0 {
            userYear = "First"
        } else if yearDifference == 1 {
            userYear = "Second"
        } else if yearDifference == 2 {
            userYear = "Third"
        } else if yearDifference == 3 {
            userYear = "Fourth"
        } else if yearDifference == 4 {
            userYear = "Fifth"
        } else if yearDifference == 5 {
            userYear = "Sixth"
        } else {
            userYear = "Fuoricorso"
        }
    }

    /// Funzione per validare se l'URL è corretto
    func isValidURL(_ url: String) -> Bool {
        guard let url = URL(string: url) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }

    /// Funzione per validare e mostrare l'errore
    func validateLink() {
        if !isValidURL(newLinkURL) {
            showError = true
        } else {
            showError = false
        }
    }
}

#Preview {
    NavigationStack {
        ProfilePage(userEmail: "example@studenti.unina.it")
    }
}
