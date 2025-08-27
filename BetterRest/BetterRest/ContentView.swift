//
//  ContentView.swift
//  BetterRest
//
//  Created by Parmesh Yadav on 21/08/25.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var showRecommendation = false
    
    static var defaultWakeTime: Date {
        var comp = DateComponents()
        comp.hour = 7
        comp.minute = 0
        return Calendar.current.date(from: comp) ?? .now
    }
    
    var recommendedBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try BetterRestMLModel(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [
                        Color(.systemIndigo).opacity(0.1),
                        Color(.systemPurple).opacity(0.05),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "moon.stars.fill")
                                    .font(.title2)
                                    .foregroundStyle(.indigo)
                                
                                Spacer()
                                
                                Text("BetterRest")
                                    .font(.largeTitle.weight(.bold))
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "sun.max.fill")
                                    .font(.title2)
                                    .foregroundStyle(.orange)
                            }
                            
                            Text("Optimize your sleep schedule")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Main content cards
                        VStack(spacing: 20) {
                            // Wake up time card
                            ModernCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "alarm.fill")
                                            .font(.title3)
                                            .foregroundStyle(.indigo)
                                        
                                        Text("Wake Up Time")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                    }
                                    
                                    DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(.wheel)
                                        .labelsHidden()
                                        .scaleEffect(0.9)
                                }
                            }
                            
                            // Sleep amount card
                            ModernCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "bed.double.fill")
                                            .font(.title3)
                                            .foregroundStyle(.purple)
                                        
                                        Text("Desired Sleep")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                        
                                        Text("\(sleepAmount.formatted()) hrs")
                                            .font(.title3.weight(.bold))
                                            .foregroundStyle(.purple)
                                    }
                                    
                                    HStack(spacing: 16) {
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                if sleepAmount > 4 {
                                                    sleepAmount -= 0.25
                                                }
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundStyle(.purple)
                                        }
                                        .disabled(sleepAmount <= 4)
                                        
                                        Slider(value: $sleepAmount, in: 4...12, step: 0.25)
                                            .tint(.purple)
                                        
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                if sleepAmount < 12 {
                                                    sleepAmount += 0.25
                                                }
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundStyle(.purple)
                                        }
                                        .disabled(sleepAmount >= 12)
                                    }
                                }
                            }
                            
                            // Coffee intake card
                            ModernCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "cup.and.saucer.fill")
                                            .font(.title3)
                                            .foregroundStyle(.brown)
                                        
                                        Text("Daily Coffee")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                        
                                        Text("^[\(coffeeAmount) cup](inflect:true)")
                                            .font(.title3.weight(.bold))
                                            .foregroundStyle(.brown)
                                    }
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                                        ForEach(1..<21) { number in
                                            Button(action: {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    coffeeAmount = number
                                                }
                                            }) {
                                                Text("\(number)")
                                                    .font(.callout.weight(.semibold))
                                                    .foregroundStyle(coffeeAmount == number ? .white : .brown)
                                                    .frame(width: 36, height: 36)
                                                    .background(
                                                        Circle()
                                                            .fill(coffeeAmount == number ? .brown : Color(.systemGray6))
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Recommendation card
                            ModernCard {
                                VStack(spacing: 20) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                            .font(.title3)
                                            .foregroundStyle(.mint)
                                        
                                        Text("Your Ideal Bedtime")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                    }
                                    
                                    VStack(spacing: 8) {
                                        Text(recommendedBedtime)
                                            .font(.system(size: 48, weight: .bold, design: .rounded))
                                            .foregroundStyle(.mint)
                                            .contentTransition(.numericText())
                                        
                                        Text("Get to bed by this time for optimal rest")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.mint.opacity(0.1))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
        }
        .onChange(of: wakeUp) { _, _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                showRecommendation.toggle()
            }
        }
        .onChange(of: sleepAmount) { _, _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                showRecommendation.toggle()
            }
        }
        .onChange(of: coffeeAmount) { _, _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                showRecommendation.toggle()
            }
        }
    }
}

struct ModernCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            )
    }
}

#Preview {
    ContentView()
}
