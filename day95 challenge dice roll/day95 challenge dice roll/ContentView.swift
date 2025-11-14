//
//  ContentView.swift
//  day95 challenge dice roll
//
//  Created by Parmesh Yadav on 14/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Roll.date, order: .reverse) private var rolls: [Roll]
    
    @State private var currentValue = 1
    @State private var diceSides = 6
    @State private var flickerTimer: Timer?
    @State private var isFlicking = true
    
    let allDice = [4, 6, 8, 10, 12, 20, 100]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(currentValue)")
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal)
                    .animation(.easeOut(duration: 0.2), value: currentValue)
                
                Picker("Dice Type", selection: $diceSides) {
                    ForEach(allDice, id: \.self) { side in
                        Text("\(side)")
                            .tag(side)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                Button("Roll Dice", action: rollDice)
                    .font(.title2.bold())
                    .padding(.vertical, 12)
                    .padding(.horizontal, 40)
                    .background(.blue.gradient)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                    .shadow(radius: 4, y: 2)
                
                Divider()
                
                List {
                    ForEach(rolls) { roll in
                        VStack(alignment: .leading) {
                            Text("Rolled: \(roll.value)")
                                .font(.headline)
                            
                            Text(roll.date.formatted(date: .numeric, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                        .overlay(
                            Divider()
                                .offset(y: 8),
                            alignment: .bottom
                        )
                    }
                    .onDelete(perform: deleteRolls)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
                .clipShape(.rect(cornerRadius: 12))
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Dice Roller")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem {
                    Button("Clear All", action: clearAll)
                        .foregroundStyle(rolls.isEmpty ? .gray: .red)
                        .disabled(rolls.isEmpty)
                }
            }
        }
    }
    
    func rollDice() {
        haptic()
        
        isFlicking = true
        var ticks = 0
        let totalTicks = 30
        
        flickerTimer?.invalidate()
        
        flickerTimer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            ticks += 1
            currentValue = Int.random(in: 1...diceSides)
            if ticks >= totalTicks {
                timer.invalidate()
                finishRoll()
            }
        }
    }
    
    func finishRoll() {
        isFlicking = false
        
        let finalValue = Int.random(in: 1...diceSides)
        currentValue = finalValue
        
        let newRoll = Roll(value: finalValue, date: Date.now)
        modelContext.insert(newRoll)
    }
    
    func haptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func deleteRolls(at offsets: IndexSet) {
        for index in offsets {
            let roll = rolls[index]
            modelContext.delete(roll)
        }
    }
    
    func clearAll() {
        for roll in rolls {
            modelContext.delete(roll)
        }
    }
    
}

#Preview {
    ContentView()
}
