//
//  Activities.swift
//  habit-tracking
//
//  Created by Parmesh Yadav on 15/09/25.
//

import Foundation


class Activities: ObservableObject {
    @Published var activities: [Activity] = [] {
        didSet {
            save()
        }
    }
    
    private let saveKey = "Activities"
    
    init() {
        load()
    }
    
    func add(title: String, description: String) {
        let newActivity = Activity(title: title, description: description)
        activities.append(newActivity)
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: data) {
                activities = decoded
            }
        }
    }
}
