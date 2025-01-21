//SignUpPage.swift

import SwiftUI

struct SignUpPage: View {
    @State private var user: RegisteringUser = RegisteringUser()  // User data model
    @State private var showDatePicker: Bool = false  // Toggle for DatePicker visibility
    @State private var navigateToHome = false  // Control navigation to the Home page
    @Environment(\.dismiss) private var dismiss  // Dismiss the view
    @State private var selectedMajor: String = "Select your major"  // Placeholder for major selection
    let majors = ["Computer Science", "Engineering", "Mathematics", "Physics", "Law", "Medicine"]  // List of majors

    var body: some View {
        NavigationStack {
            Form {
                // Name and surname input
                Section("Name and surname") {
                    TextField("Ricky Puggiosk", text: $user.nameAndSurname)
                }
                
                // Major selection
                Section("Select your major") {
                    Picker(selection: $selectedMajor, label: Text(selectedMajor).foregroundColor(selectedMajor == "Select your major" ? .gray.opacity(0.5) : .black)) {
                        ForEach(majors, id: \.self) { major in
                            Text(major).tag(major)
                        }
                    }
                }
                
                // Registration date selection
                Section("Registration Date") {
                    Button(action: {
                        withAnimation {
                            showDatePicker.toggle()  // Toggle date picker visibility
                        }
                    }) {
                        HStack {
                            Text(user.registrationDate, style: .date)  // Display selected date
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                    
                    // Display DatePicker if toggle is true
                    if showDatePicker {
                        DatePicker(
                            "Select your registration date",
                            selection: $user.registrationDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(WheelDatePickerStyle())  // Wheel style for DatePicker
                        .labelsHidden()
                        .padding(.top, 10)
                    }
                }
                
                // Email input
                Section("E-mail") {
                    TextField("name @studenti.unina.it", text: $user.email)
                }
                
                // Password input
                Section("Password") {
                    SecureField("Password", text: $user.password)
                }
                
                // Confirm password input
                Section("Confirm Password") {
                    SecureField("Confirm Password", text: $user.confirmPassword)
                }

                .navigationBarTitleDisplayMode(.inline)
                
                VStack {
                    // Confirm registration button
                    Button("Confirm registration") {
                        navigateToHome = true  // Navigate to home page
                        dismiss()  // Dismiss current sheet
                    }
                    .frame(maxWidth: .infinity)
                    .font(.title)
                    .bold()
                    .foregroundColor(.accentColor)
                    
                    // Navigation to WelcomePage after registration confirmation
                }
                .navigationDestination(isPresented: $navigateToHome) {
                    WelcomePage()  // Redirect to the Welcome page
                }
            }
            .navigationTitle("Signup")
        }
    }
}

struct RegisteringUser {
    @State var email: String = ""  // Email
    @State var password: String = ""  // Password
    @State var confirmPassword: String = ""  // Confirm Password
    @State var nameAndSurname: String = ""  // Full name
    @State var registrationDate: Date = Date()  // Default registration date
}

#Preview {
    SignUpPage()
}
