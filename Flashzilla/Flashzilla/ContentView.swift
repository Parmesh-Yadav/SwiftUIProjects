//
//  ContentView.swift
//  Flashzilla
//
//  Created by Parmesh Yadav on 03/11/25.
//

import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default,_ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency
    @State private var scale = 1.0

    var body: some View {
        Text("Hello World")
            .padding()
            .background(accessibilityReduceTransparency ? .black : .black.opacity(0.5))
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
    
}

#Preview {
    ContentView()
}
