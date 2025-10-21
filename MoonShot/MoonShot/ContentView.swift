//
//  ContentView.swift
//  MoonShot
//
//  Created by Parmesh Yadav on 01/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showGrid = false
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            Group{
                if showGrid {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(missions) { mission in
                                NavigationLink(value: mission) {
                                    VStack {
                                        Image(mission.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        
                                        VStack {
                                            Text(mission.displayName)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text(mission.formattedLaunchDate)
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                        }
                                        .padding(.vertical)
                                        .frame(maxWidth: .infinity)
                                        .background(.lightBackground)
                                    }
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.lightBackground)
                                    )
                                }
                                
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                }
                else {
                    List(missions) { mission in
                        NavigationLink(value: mission) {
                            HStack{
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                VStack(alignment: .leading){
                                    Text(mission.displayName)
                                        .font(.headline)
                                    
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical,4)
                            .frame(maxWidth: .infinity)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("\(mission.displayName), launched \(mission.formattedLaunchDate)")
                            .accessibilityHint("Double-tap for more mission details")
                        }
                    }
                    .listStyle(.plain)
                    .listRowBackground(.dark)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            showGrid.toggle()
                        }
                    } label: {
                        Image(systemName: showGrid ? "list.bullet" : "square.grid.2x2")
                    }
                }
            }
            .navigationDestination(for: Mission.self) { mission in
                MissionView(mission: mission, astronauts: astronauts)
            }
            .navigationDestination(for: Astronaut.self) { astronaut in
                AstronautView(astronaut: astronaut)
            }
        }
    }
}

#Preview {
    ContentView()
}
