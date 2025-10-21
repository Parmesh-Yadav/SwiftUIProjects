//
//  AstronautView.swift
//  MoonShot
//
//  Created by Parmesh Yadav on 08/09/25.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Photo of \(astronaut.name)")
                
                Text(astronaut.description)
                    .padding()
                    .accessibilityLabel(astronaut.description)
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
