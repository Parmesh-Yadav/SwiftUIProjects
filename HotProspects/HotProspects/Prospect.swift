//
//  Prospect.swift
//  HotProspects
//
//  Created by Parmesh Yadav on 29/10/25.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var email: String
    var isContacted: Bool
    
    init(name: String, email: String, isContacted: Bool) {
        self.name = name
        self.email = email
        self.isContacted = isContacted
    }
}
