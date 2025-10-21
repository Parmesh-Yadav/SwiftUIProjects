//
//  AstronautsHorizontalScrollView.swift
//  MoonShot
//
//  Created by Parmesh Yadav on 09/09/25.
//

import SwiftUI

struct AstronautsHorizontalScrollView: View {
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id:\.role) { crewMember in
                    NavigationLink(value: crewMember.astronaut) {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                
                                Text(crewMember.role)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(crewMember.astronaut.name), \(crewMember.role)")
                        .accessibilityHint("Double-tap for more details about \(crewMember.astronaut.name)")
                    }
                }
            }
        }
    }
}

//#Preview {
//    AstronautsHorizontalScrollView()
//}
