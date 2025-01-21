//  OtherProfilePage.swift

import SwiftUI

struct OtherProfilePage: View {
    @State private var userName: String = "John Appleseed"
    let userEmail: String
    @State private var userMajor: String = "Computer Engineering"
    @State private var userYear: String = "First"
    @State private var profileImageURL: URL? = URL(string: "https://www.gravatar.com/avatar/fefvwsv?s=200&d=mp")

    // customed link
    @State private var customLinks: [String] = [
        "https://www.instagram.com/example",
        "https://www.github.com/example"
    ]
    
    // Variabile userDate (year of enrollment)
    @State private var userDate: Date = Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 1)) ?? Date()

    var body: some View {
        VStack {
            // Header with image e base info immagine
            VStack(spacing: 10) {
                AsyncImage(url: profileImageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                }
                .padding()

                Text(userName)
                    .font(.title)
                    .bold()

                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("INFO")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    Label("Major", systemImage: "desktopcomputer")
                        .font(.body)
                    Spacer()
                    Text(userMajor)
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

                Text("LINKS")
                    .font(.caption)
                    .foregroundColor(.gray)

                // View the link without the possibility to  modify it
                ForEach(customLinks, id: \.self) { link in
                    HStack {
                        Text(link)
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)

            // Bottoni di navigazione
            VStack(spacing: 1) {
                NavigationLink(destination: OtherProfileQuestionPage()) {
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

                NavigationLink(destination: OtherProfileAnswerPage()) {
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
        .onAppear {
            updateYear() // Calculate the year
        }
    }

    ///Function to calculate the university year based on the enrollment date
    func updateYear() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let enrollmentYear = Calendar.current.component(.year, from: userDate)

        //Calculates the difference between the current year and the enrollment year"
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
}

#Preview {
    NavigationStack {
        OtherProfilePage(userEmail: "example@studenti.unina.it")
    }
}

