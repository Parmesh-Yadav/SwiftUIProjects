//
//  day77_challengeApp.swift
//  day77-challenge
//
//  Created by Parmesh Yadav on 22/10/25.
//

import SwiftUI

@main
struct day77_challengeApp: App {
    @StateObject private var data = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
        }
    }
}
