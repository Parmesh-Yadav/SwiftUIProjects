//
//  ContentView.swift
//  HotProspects
//
//  Created by Parmesh Yadav on 26/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "One"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Button("Show tab 2") {
                selectedTab = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")
            
            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
        }
    }
}

#Preview {
    ContentView()
}
