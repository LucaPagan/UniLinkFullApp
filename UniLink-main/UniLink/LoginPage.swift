//LoginPage.swift

import SwiftUI

struct LoginPage: View {
    @Binding var userId: String  // Binds email to external state
    @State var password: String = ""  // Default password
    @State var email: String = ""
    @Environment(\.dismiss) private var dismiss  // Dismiss sheet
    @Binding var loginState: Bool  // Track login state
    @Binding var showLoginSheet: Bool  // Control sheet visibility

    var body: some View {
        NavigationStack {
            Form {
                // Email input
                Section("E-mail") {
                    TextField("E-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                }

                // Password input
                Section("Password") {
                    SecureField("Password", text: $password)
                }

                // Login button
                Button(action: {
                    if !email.isEmpty
                        && email.elementsEqual("L.pagano@studenti.unina.it")
                        && !password.isEmpty && password.elementsEqual("test")
                    {

                        userId = "238F49D6-1C33-49DE-91A4-000B1946C73C"

                        loginState = true  // Successful login
                        dismiss()  // Close sheet
                        showLoginSheet = false  // Close the login sheet
                    } else if !email.isEmpty
                        && email.elementsEqual("R.puggioni@studenti.unina.it")
                        && !password.isEmpty && password.elementsEqual("test")
                    {

                        userId = "84DA6B51-6DD0-46F8-83E0-88A4E86BEC31"

                        loginState = true  // Successful login
                        dismiss()  // Close sheet
                        showLoginSheet = false  // Close the login sheet
                    } else if !email.isEmpty
                        && email.elementsEqual("R.palumbo@studenti.unina.it")
                        && !password.isEmpty && password.elementsEqual("test")
                    {

                        userId = "EABDAEE4-7963-431D-B8BD-823DC2AB7B96"

                        loginState = true  // Successful login
                        dismiss()  // Close sheet
                        showLoginSheet = false  // Close the login sheet
                    } else if !email.isEmpty
                        && email.elementsEqual("L.apicella@studenti.unina.it")
                        && !password.isEmpty && password.elementsEqual("test")
                    {

                        userId = "E03F16A6-0BE7-4CCD-8D67-D5C878A326A0"

                        loginState = true  // Successful login
                        dismiss()  // Close sheet
                        showLoginSheet = false  // Close the login sheet
                    } else if !email.isEmpty
                        && email.elementsEqual("F.severino@studenti.unina.it")
                        && !password.isEmpty && password.elementsEqual("test")
                    {

                        userId = "238F49D6-1C33-49DE-91A4-000B1946C73C"

                        loginState = true  // Successful login
                        dismiss()  // Close sheet
                        showLoginSheet = false  // Close the login sheet
                    } else if !email.isEmpty
                                && email.elementsEqual("T")
                                && !password.isEmpty && password.elementsEqual("t")
                            {

                                userId = "238F49D6-1C33-49DE-91A4-000B1946C73C"

                                loginState = true  // Successful login
                                dismiss()  // Close sheet
                                showLoginSheet = false  // Close the login sheet
                            }
                    
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.accentColor)
                        .font(.title)
                        .bold()
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Login")  // Title for the page
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginPage(
        userId: .constant("D997B22D-B404-48B1-BBF9-77ACC926EB25"),
        loginState: .constant(false),
        showLoginSheet: .constant(true))
}
