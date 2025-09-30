//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Parmesh Yadav on 28/08/25.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
