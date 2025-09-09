//
//  MissionView.swift
//  MoonShot
//
//  Created by Parmesh Yadav on 08/09/25.
//

import SwiftUI

struct MissionView: View {
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                
                Text(mission.formattedLaunchDate)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .padding(.top, 5)
                
                VStack(alignment: .leading) {
                    RectangleDividersView()
                    
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom,5)
                    
                    Text(mission.description)
                    
                    RectangleDividersView()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom,5)
                }
                .padding(.horizontal)
                
                AstronautsHorizontalScrollView(crew: crew)
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astronauts: [String:Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map{ member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing astronaut for \(member.name)")
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    MissionView(mission: missions[1], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
