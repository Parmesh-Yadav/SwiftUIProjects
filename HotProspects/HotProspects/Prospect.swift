//
//  Prospect.swift
//  HotProspects
//
//  Created by Parmesh Yadav on 29/10/25.
//

import Foundation
import SwiftData

@Model
class Prospect: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var email: String
    var isContacted: Bool
    var dateAdded: Date
    
    init(name: String, email: String, isContacted: Bool) {
        self.name = name
        self.email = email
        self.isContacted = isContacted
        self.dateAdded = Date()
    }
}
