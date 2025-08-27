//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Parmesh Yadav on 18/08/25.
//

import SwiftUI

struct GridStack<Content:View> : View {
    var rows: Int
    var columns: Int
    @ViewBuilder let content: (Int,Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns,id:\.self) { col in
                        content(row,col)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var isRed: Bool = false
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            Image(systemName: "\(row*4+col).circle")
            Text("R\(row), C\(col)")
        }
    }
}

#Preview {
    ContentView()
}
