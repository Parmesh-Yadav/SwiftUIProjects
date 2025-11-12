//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Parmesh Yadav on 10/11/25.
//

import SwiftUI


struct ContentView: View {

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color(
                                    hue: Double(proxy.frame(in: .global).minY / fullView.size.height),
                                    saturation: 0.8,
                                    brightness: 0.9
                                )
                            )
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(
                                (proxy.frame(in: .global).minY > 200)
                                ? 1
                                : proxy.frame(in: .global).minY / 200
                            )
                            .scaleEffect(
                                max(0.5, proxy.frame(in: .global).minY / fullView.size.height)
                            )
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
