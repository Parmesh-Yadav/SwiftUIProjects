//
//  ActivityDetailView.swift
//  habit-tracking
//
//  Created by Parmesh Yadav on 15/09/25.
//

import SwiftUI

struct ActivityDetailView: View {
    @EnvironmentObject var activities: Activities
    var activity: Activity
    
    var body: some View {
        VStack(spacing: 20) {
            Text(activity.description)
                .font(.body)
                .padding()
            
            Text("Completed \(activity.completionCount) times")
                .font(.headline)
            
            Button("Mark as Completed") {
                incrementCompletion()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Spacer()
        }
    .navigationTitle(activity.title)
    .navigationBarTitleDisplayMode(.inline)
    }
    
    private func incrementCompletion() {
        if let index = activities.activities.firstIndex(where: { $0.id == activity.id }) {
            var updated = activities.activities[index]
            updated.completionCount += 1
            activities.activities[index] = updated
        }
    }
}

#Preview {
    ActivityDetailView(activity: Activity(title: "title1", description: "description1"))
        .environmentObject(Activities())
}
