//
//  AddView.swift
//  iExpense
//
//  Created by Parmesh Yadav on 30/08/25.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @State private var name = "name of expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currency = "INR"
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let types = ["Businness", "Personal"]
    let currencies = ["INR", "USD", "EUR"]
    
    var body: some View {
            Form {
                
                Section("Type of expense") {
                    Picker("Type", selection: $type) {
                        ForEach(types,id:\.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Amount & Currency") {
                    TextField("Amount", value: $amount, format: .currency(code: currency))
                        .keyboardType(.decimalPad)
                    Picker("Currency", selection: $currency){
                        ForEach(currencies, id:\.self){
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                    modelContext.insert(item)
                    dismiss()
                }
            }
    }
}

#Preview {
    AddView()
}
