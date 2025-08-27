//
//  ContentView.swift
//  edutainment
//
//  Created by Parmesh Yadav on 27/08/25.
//

import SwiftUI

struct Question {
    let text: String
    let ans: Int
}

struct ContentView: View {
    
    @State private var gameStarted = false
    @State private var maxTable = 12
    @State private var questionCount = 10
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var userAnswer = ""
    @State private var questions: [Question] = []
    @State private var showResult = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if !gameStarted {
                    settingsView
                }
                else if showResult {
                    resultsView
                }
                else{
                    gameView
                }
            }
        }
    }
    
    var settingsView: some View {
        VStack(spacing: 30){
            
            Text("Let's practice Multiplication!")
                .font(.title)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                
                Text("Practise up to: \(maxTable) times table")
                
                Stepper("Up to \(maxTable)", value: $maxTable, in: 2...12)
                    .labelsHidden()
                
            }
            
            VStack(spacing: 15) {
                
                Text("Number of questions: \(questionCount)")
                
                HStack{
                    
                    Button("5") {
                        questionCount = 5
                    }
                    .buttonStyle(questionButtonStyle(isSelected: questionCount == 5))
                    
                    Button("10") {
                        questionCount = 10
                    }
                    .buttonStyle(questionButtonStyle(isSelected: questionCount == 10))
                    
                    Button("20") {
                        questionCount = 20
                    }
                    .buttonStyle(questionButtonStyle(isSelected: questionCount == 20))
                    
                }
                
            }
            
            Button("Start Game") {
                startGame()
            }
            .font(.title2)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
            
        }
    }
    
    var gameView: some View {
        VStack(spacing: 30){
            
            Text("Question \(currentQuestionIndex + 1)/\(questionCount)")
                .font(.headline)
            
            if currentQuestionIndex < questionCount {
                Text(questions[currentQuestionIndex].text)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            TextField("Your answer", text: $userAnswer)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title)
                .multilineTextAlignment(.center)
            
            Button("Submit Answer") {
                submitAnswer()
            }
            .font(.title2)
            .foregroundStyle(.white)
            .padding()
            .background(userAnswer.isEmpty ? .gray : .green)
            .cornerRadius(10)
            .disabled(userAnswer.isEmpty)
            
        }
    }
    
    var resultsView: some View {
        VStack(spacing: 30) {
            
            Text("Great Job!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("You got \(score)/\(questionCount) correct")
                .font(.title)
            
            Text("That's \(String(format: "%.2f", Double(score) / Double(questionCount) * 100))%")
                .font(.title2)
                .foregroundStyle(.blue)
            
            Button("Play Again") {
                resetGame()
            }
            .font(.title2)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .cornerRadius(10)
            
        }
    }
    
    func startGame() {
        generateQuestion()
        gameStarted = true
        currentQuestionIndex = 0
        score = 0
        userAnswer = ""
        showResult = false
    }
    
    func resetGame() {
        gameStarted = false
        showResult = false
        userAnswer = ""
    }
    
    func generateQuestion() {
        questions = []
        for _ in 0..<questionCount {
            let firstNumber = Int.random(in: 2...maxTable)
            let secondNumber = Int.random(in: 2...12)
            let answer = firstNumber * secondNumber
            
            let question = Question(text: "\(firstNumber) x \(secondNumber) = ?", ans: answer)
            questions.append(question)
        }
    }
    
    func submitAnswer() {
        guard let userAnswerInt = Int(userAnswer) else { return }
        if userAnswerInt == questions[currentQuestionIndex].ans {
            score += 1
        }
        if currentQuestionIndex < questionCount - 1 {
            currentQuestionIndex += 1
            userAnswer = ""
        }
        else{
            showResult = true
        }
    }
}

struct questionButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isSelected ? .blue : .gray.opacity(0.3))
            .foregroundStyle(isSelected ? .white : .primary)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    ContentView()
}
