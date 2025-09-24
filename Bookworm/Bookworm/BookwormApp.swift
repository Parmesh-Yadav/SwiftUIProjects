//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Parmesh Yadav on 23/09/25.
//

import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
