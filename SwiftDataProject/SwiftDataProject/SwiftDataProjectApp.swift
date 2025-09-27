//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Parmesh Yadav on 27/09/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
