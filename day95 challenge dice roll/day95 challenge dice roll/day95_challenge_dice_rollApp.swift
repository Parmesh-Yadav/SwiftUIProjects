//
//  day95_challenge_dice_rollApp.swift
//  day95 challenge dice roll
//
//  Created by Parmesh Yadav on 14/11/25.
//

import SwiftUI
import SwiftData

@main
struct day95_challenge_dice_rollApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Roll.self)
    }
}
