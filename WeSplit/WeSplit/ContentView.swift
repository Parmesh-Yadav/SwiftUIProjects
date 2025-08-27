//
//  ContentView.swift
//  WeSplit
//
//  Created by Parmesh Yadav on 12/08/25.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var checkAmount = 0.0
    @State private var noOfPeople = 2
    @State private var tipPercentage = 20
    
    let tipPercentages = Array(0..<101)
    
    var totalAmount: Double {
        let tipValue = checkAmount/100 * Double(tipPercentage)
        return checkAmount + tipValue
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(noOfPeople + 2)
        let amountPerPerson = totalAmount/peopleCount
        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of people",selection: $noOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section("How much would you like to tip?") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0,format: .percent)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section("Total amount") {
                    Text(totalAmount,format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                        .foregroundStyle(tipPercentage == 0 ? .red : .blue)
                }
                Section("Amount per person") {
                    Text(totalPerPerson,format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
