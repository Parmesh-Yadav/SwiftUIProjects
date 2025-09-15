//
//  habit_trackingApp.swift
//  habit-tracking
//
//  Created by Parmesh Yadav on 15/09/25.
//

import SwiftUI

@main
struct habit_trackingApp: App {
    @StateObject private var activities = Activities()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(activities)
        }
    }
}
