//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Parmesh Yadav on 10/11/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .background(.blue)
            .offset(x: 100, y: 100)
            .background(.red)
    }
}

#Preview {
    ContentView()
}
