//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Parmesh Yadav on 26/10/25.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
