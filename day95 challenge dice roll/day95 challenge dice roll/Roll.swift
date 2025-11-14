//
//  Roll.swift
//  day95 challenge dice roll
//
//  Created by Parmesh Yadav on 14/11/25.
//

import Foundation
import SwiftData

@Model
class Roll {
    var value: Int
    var date: Date
    
    init(value: Int, date: Date) {
        self.value = value
        self.date = date
    }
}
