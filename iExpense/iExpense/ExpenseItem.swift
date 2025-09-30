//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Parmesh Yadav on 30/09/25.
//

import Foundation
import SwiftData

@Model
class ExpenseItem{
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
    var currency: String
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double, currency: String) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
    }
}
