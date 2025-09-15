//
//  ContentView.swift
//  habit-tracking
//
//  Created by Parmesh Yadav on 15/09/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var activities: Activities
    @State private var showAddActivity = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities.activities) { activity in
                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                        VStack(alignment: .leading) {
                            Text(activity.title)
                                .font(.headline)
                            
                            Text(activity.description)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle(("My Habits"))
            .toolbar {
                ToolbarItem {
                    Button {
                        showAddActivity = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddActivity) {
                AddActivityView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Activities())
}
