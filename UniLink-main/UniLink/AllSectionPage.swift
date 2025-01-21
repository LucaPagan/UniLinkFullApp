//
//  AllSectionPage.swift
//  UniLink
//
//  Created by Luca Pagano on 08/12/24.
//
import SwiftUI

struct AllSectionPage: View {
    var body: some View {
        VStack {
            List(CorsoDiStudio.allCases, id: \.self) { corso in
                NavigationLink(destination: ListOfQuestionPage(corsoDiStudio: corso)) {
                    HStack {
                        Image(systemName: corso.imageName)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        Text(corso.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Sections")
    }
}

#Preview {
    NavigationStack {
        AllSectionPage()
    }
}
