//
//  ContentView.swift
//  Animations
//
//  Created by Parmesh Yadav on 24/08/25.
//

import SwiftUI

struct cornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: cornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: cornerRotateModifier(amount: 0, anchor: .topLeading),
        )
    }
}

struct ContentView: View {
    
    @State private var isShowingRed = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot) // Use your custom transition here
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
