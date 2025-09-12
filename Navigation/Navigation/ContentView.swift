//
//  ContentView.swift
//  Navigation
//
//  Created by Parmesh Yadav on 10/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var title: String = "Swift UI"
    
    var body: some View {
        NavigationStack {
            Text("Hello World")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
