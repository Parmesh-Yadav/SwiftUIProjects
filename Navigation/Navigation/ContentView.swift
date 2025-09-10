//
//  ContentView.swift
//  Navigation
//
//  Created by Parmesh Yadav on 10/09/25.
//

import SwiftUI

struct Student: Hashable {
    var id: UUID
    var name: String
    var age: Int
}

struct DetailView: View {
    var number: Int
    
    var body: some View {
        Text("Detail View \(number)")
    }
    
    init(number: Int) {
        self.number = number
        print("Creating DetailView \(number)")
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                NavigationLink("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self) { selection in
                DetailView(number: selection)
            }
            .navigationDestination(for: Student.self){ student in
                Text("You selected \(student.id) \(student.name) \(student.age)")
            }
        }
    }
}k

#Preview {
    ContentView()
}
