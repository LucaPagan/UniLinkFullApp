//  UniLinkApp.swift



import SwiftUI

@main
struct UniLinkApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomePage()
                .onAppear {
                    UserDefaults.standard.set("GzciWbr/EPLumVFAzlYQZQ==", forKey: "StudentToken")
                }
        }
    }
}
