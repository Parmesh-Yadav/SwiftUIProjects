//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Parmesh Yadav on 27/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<User> { user in
        user.name.localizedStandardContains("R") &&
        user.city == "London"
    },sort: \User.name) var users: [User]
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                Text(user.name)
            }
            .navigationTitle("Users")
            .toolbar {
                Button("Add Samples", systemImage: "plus") {
                    try? modelContext.delete(model: User.self)
                    
                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = User(name: "Rosa Diaz", city: "New york", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = User(name: "Katy Perry", city: "Los Angeles", joinDate: .now.addingTimeInterval(86400 * -15))
                    let fourth = User(name: "Taylor Swift", city: "Chicago", joinDate: .now.addingTimeInterval(86400 * -20))
                    
                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
