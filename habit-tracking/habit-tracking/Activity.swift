//
//  Activity.swift
//  habit-tracking
//
//  Created by Parmesh Yadav on 15/09/25.
//

import Foundation

struct Activity: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var completionCount: Int = 0
}
