//
//  Day60ChallengeApp.swift
//  Day60Challenge
//
//  Created by Parmesh Yadav on 01/10/25.
//

import SwiftUI
import SwiftData

@main
struct Day60ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Friend.self])
    }
}
