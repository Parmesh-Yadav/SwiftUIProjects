//
//  ContentView.swift
//  UnitConversion
//
//  Created by Parmesh Yadav on 14/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit: String = "Celcius"
    @State private var outputUnit: String = "Fahrenheit"
    @State private var inputValue: Double = 0.0
    
    var outputValue: Double {
        if(inputUnit == outputUnit) {
            return inputValue
        }
        // Convert input to Celsius first
        let celsius: Double
        switch inputUnit {
        case "Celcius":
            celsius = inputValue
        case "Fahrenheit":
            celsius = (inputValue - 32) * 5/9
        case "Kelvin":
            celsius = inputValue - 273.15
        default:
            celsius = inputValue
        }
            
        // Convert from Celsius to output unit
        switch outputUnit {
        case "Celcius":
            return celsius
        case "Fahrenheit":
            return (celsius * 9/5) + 32
        case "Kelvin":
            return celsius + 273.15
        default:
            return celsius
        }
    }
    
    let units: [String] = ["Celcius", "Fahrenheit", "Kelvin"]
    
    private func getUnitSymbol(for unit: String) -> String {
            switch unit {
            case "Celcius":
                return "C"
            case "Fahrenheit":
                return "F"
            case "Kelvin":
                return "K"
            default:
                return ""
            }
        }
    
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Ultra-minimal background
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack(spacing: 60) {
                        // Floating title
                        Text("TEMP")
                            .font(.system(size: 14, weight: .ultraLight, design: .monospaced))
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(8)
                        
                        VStack(spacing: 80) {
                            // Input Section
                            VStack(spacing: 40) {
                                // Input value display
                                HStack {
                                    Spacer()
                                    TextField("0", value: $inputValue, format: .number)
                                        .font(.system(size: 72, weight: .ultraLight, design: .monospaced))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.decimalPad)
                                        .background(Color.clear)
                                    Text(getUnitSymbol(for: inputUnit))
                                        .font(.system(size: 24, weight: .ultraLight, design: .monospaced))
                                        .foregroundColor(.white.opacity(0.4))
                                        .offset(x: -20, y: -20)
                                    Spacer()
                                }
                                
                                // Input unit selector
                                HStack(spacing: 0) {
                                    ForEach(units, id: \.self) { unit in
                                        Button(action: { inputUnit = unit }) {
                                            Text(getUnitSymbol(for: unit))
                                                .font(.system(size: 16, weight: .ultraLight, design: .monospaced))
                                                .foregroundColor(inputUnit == unit ? .white : .white.opacity(0.3))
                                                .frame(width: 40, height: 40)
                                                .background(
                                                    Circle()
                                                        .stroke(inputUnit == unit ? .white.opacity(0.3) : .clear, lineWidth: 0.5)
                                                )
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                }
                            }
                            
                            // Conversion indicator
                            VStack(spacing: 20) {
                                Rectangle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 1, height: 60)
                                
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 2, height: 2)
                                
                                Rectangle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 1, height: 60)
                            }
                            
                            // Output Section
                            VStack(spacing: 40) {
                                // Output value display
                                HStack {
                                    Spacer()
                                    Text("\(outputValue, specifier: "%.1f")")
                                        .font(.system(size: 72, weight: .ultraLight, design: .monospaced))
                                        .foregroundColor(.white.opacity(0.9))
                                    Text(getUnitSymbol(for: outputUnit))
                                        .font(.system(size: 24, weight: .ultraLight, design: .monospaced))
                                        .foregroundColor(.white.opacity(0.4))
                                        .offset(x: -20, y: -20)
                                    Spacer()
                                }
                                
                                // Output unit selector
                                HStack(spacing: 0) {
                                    ForEach(units, id: \.self) { unit in
                                        Button(action: { outputUnit = unit }) {
                                            Text(getUnitSymbol(for: unit))
                                                .font(.system(size: 16, weight: .ultraLight, design: .monospaced))
                                                .foregroundColor(outputUnit == unit ? .white : .white.opacity(0.3))
                                                .frame(width: 40, height: 40)
                                                .background(
                                                    Circle()
                                                        .stroke(outputUnit == unit ? .white.opacity(0.3) : .clear, lineWidth: 0.5)
                                                )
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 40)
                    .padding(.horizontal, 40)
                }
            }
            .preferredColorScheme(.dark)
            .statusBarHidden()
        }
}

#Preview {
    ContentView()
}
