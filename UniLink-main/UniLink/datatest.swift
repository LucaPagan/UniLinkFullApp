//  datatest.swift


import Foundation
import SwiftUI




var categories: [Categories] = [
    Categories(icon: "cross.case.fill", title: "Firs Aid", count: 1),
    Categories(icon: "circle", title: "General", count: 2),
    Categories(icon: "pill.fill", title: "Pharmacy", count: 1),
    Categories(icon: "ladybug.fill", title: "Agricultural", count: 2),
    Categories(icon: "eurosign.circle", title: "Economics", count: 3),
    Categories(icon: "gear", title: "Engineering", count: 4),
]


struct Categories : Identifiable{
    var id: UUID = UUID()
    var icon: String
    var title: String
    var count: Int
    
}


//struct per le categorie
//aggiungi il check per vedere il login
struct CategoryView: View {
    let category: Categories
    var body: some View {
        VStack {
            Image(systemName: category.icon)
                .font(.largeTitle)
                .foregroundColor(.blue)
            Text(category.title)
                .font(.headline)
            Text("\(category.count) Questions")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(width: 120, height: 100)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

