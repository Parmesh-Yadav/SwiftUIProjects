//
//  ContentView.swift
//  Flashzilla
//
//  Created by Parmesh Yadav on 03/11/25.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        VStack {
            Text("Hello")
            
            Spacer()
                .frame(height: 100)
            
            Text("World")
        }
        .contentShape(.rect)
        .onTapGesture {
            print("VStack tapped")
        }
    }
}

#Preview {
    ContentView()
}
