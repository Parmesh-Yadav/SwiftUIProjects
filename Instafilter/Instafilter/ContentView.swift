//
//  ContentView.swift
//  Instafilter
//
//  Created by Parmesh Yadav on 03/10/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ContentUnavailableView {
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("You don't have any save snippets yet. Click the button below to create one.")
        } actions: {
            Button("Create a snippet") {
                //logic to create snippet
            }
            .buttonStyle(.borderedProminent)
        }
    }

}

#Preview {
    ContentView()
}
