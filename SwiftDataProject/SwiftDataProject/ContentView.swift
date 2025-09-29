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
    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate)
    ]
    
    var body: some View {
        NavigationStack {
            UsersView(minJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
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
                    
                    Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                        showingUpcomingOnly.toggle()
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([SortDescriptor(\User.name),
                                      SortDescriptor(\User.joinDate)])
                            Text("Sort by join date")
                                .tag([SortDescriptor(\User.joinDate),
                                      SortDescriptor(\User.name)])
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
