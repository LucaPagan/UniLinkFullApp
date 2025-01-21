//WelcomePage.swift

import SwiftUI

struct WelcomePage: View {
    // State variables for page control, modal visibility, and user input
    @State private var selectedPage: Int = 0
    @State private var showLoginSheet: Bool = false
    @State private var showSignupSheet: Bool = false
    @State private var showHomeSheet: Bool = false
    @State private var loginState: Bool = false
    @State private var userId: String = ""

    // Images for the carousel
    let images = ["WelcomeImage1", "WelcomeImage2", "WelcomeImage3", "WelcomeImage4"]

    var body: some View {
        NavigationStack {
            VStack {
                // Logo at the top
                Image("UniLinkLogo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                    .padding(.top, 30)

                // University name and title
                VStack(spacing: 10) {
                    Text("Università degli Studi di Napoli")
                        .font(.headline)
                    Text("FEDERICO II")
                        .font(.title)
                        .foregroundColor(.blue)
                        .bold()
                }
                .padding(.bottom, 30)

                // Image carousel with page indicators
                TabView(selection: $selectedPage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 220)

                // Slogan text
                Text("Connect. Learn. Grow.")
                    .font(.subheadline)
                    .padding(.bottom, 20)

                // Page indicator dots
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedPage ? Color.black : Color.gray)
                            .frame(width: 12, height: 12)
                            .onTapGesture {
                                withAnimation { selectedPage = index }
                            }
                    }
                }
                .padding(.bottom, 40)

                // Show buttons when the last image (index 3) is selected
                if selectedPage == 3 {
                    VStack(spacing: 15) {
                        // Login button opens LoginPage sheet
                        Button(action: { showLoginSheet = true }) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 100)
                        .sheet(isPresented: $showLoginSheet) {
                            LoginPage(userId: $userId, loginState: $loginState, showLoginSheet: $showLoginSheet)
                                .presentationDetents([.fraction(0.45)])
                        }

                        // Signup button opens SignUpPage sheet
                        Button(action: { showSignupSheet = true }) {
                            Text("Signup")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 100)
                        .sheet(isPresented: $showSignupSheet) {
                            SignUpPage()
                                .presentationDetents([.fraction(0.75)])
                        }

                        // Continue as guest button navigates to HomePage
                        Button(action: { showHomeSheet = true }) {
                            Text("Continue as a guest")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 100)
                        .navigationDestination(isPresented: $showHomeSheet) {
                            HomePage(email: userId)
                        }
                    }
                    .padding(.bottom, 80)
                }

                Spacer()
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)

            // Navigation to HomePage if logged in
            .navigationDestination(isPresented: $loginState) {
                HomePage(email: userId)
            }
        }
    }
}

#Preview {
    WelcomePage()
}
