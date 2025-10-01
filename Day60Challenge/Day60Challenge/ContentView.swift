//
//  ContentView.swift
//  Day60Challenge
//
//  Created by Parmesh Yadav on 01/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink(value: user) {
                    HStack {
                        Circle()
                            .fill(user.isActive ? .green : .red)
                            .frame(width: 12, height: 12)
                        
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Friend Face")
            .navigationDestination(for: User.self) { user in
                DetailView(user: user)
            }
            .task {
                if users.isEmpty {
                    await loadData()
                }
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decoded = try decoder.decode([User].self, from: data)
            for user in decoded {
                modelContext.insert(user)
            }
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
