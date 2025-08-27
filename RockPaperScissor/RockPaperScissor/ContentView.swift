//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Parmesh Yadav on 20/08/25.
//

import SwiftUI

struct ContentView: View {
    
    private static let options = ["Rock", "Paper", "Scissors"]
    private static let emojis  = ["✊", "✋", "✌️"]
    
    @State private var appChoice = Int.random(in: 0..<Self.options.count)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var round = 1 // 1...10
    @State private var isGameOver = false
    
    private func beats(_ a: Int, _ b: Int) -> Bool {
        return (a == 0 && b == 2) || (a == 1 && b == 0) || (a == 2 && b == 1)
    }
    
    private func reset() {
        score = 0
        round = 1
        appChoice = Int.random(in: 0..<Self.options.count)
        shouldWin = Bool.random()
        isGameOver = false
    }
    
    private func playerTapped(_ player: Int) {
        let correct: Bool
        if shouldWin {
            correct = beats(player, appChoice)
        }
        else {
            correct = beats(appChoice, player)
        }
        score += correct ? 1 : -1
        if round == 10 {
            isGameOver = true
        }
        else {
            round += 1
            appChoice = Int.random(in: 0..<Self.options.count)
            shouldWin.toggle()
        }
    }
    
    var body: some View {
        VStack {
            
            VStack(spacing: 6) {
                Text("Rock Paper Scissor")
                    .font(.title.bold())
                Text("Round \(round) of 10")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Score: \(score)")
                    .font(.headline)
                    .padding(.top,4)
            }
            
            VStack(spacing: 8) {
                Text("App Played")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(Self.emojis[appChoice])
                    .font(.system(size: 80))
                Text(Self.options[appChoice])
                    .font(.title2)
                    .accessibilityLabel(Self.options[appChoice])
            }
            
            Text(shouldWin ? "You must WIN this round" : "You must LOSE this round")
                .font(.title3)
                .padding(.top,8)
            
            HStack {
                ForEach(0..<Self.options.count, id: \.self) {i in
                    Button{
                        playerTapped(i)
                    } label: {
                        VStack {
                            Text(Self.emojis[i])
                                .font(.system(size: 54))
                            Text(Self.options[i])
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityLabel(Self.options[i])
                }
            }
            Spacer(minLength: 0)
        }
        .padding()
        .alert("Game Over", isPresented: $isGameOver) {
            Button("Play Again", role: .none, action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
    }
}

#Preview {
    ContentView()
}
