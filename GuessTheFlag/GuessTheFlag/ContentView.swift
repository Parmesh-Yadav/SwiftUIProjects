import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Spain","UK","Ukraine","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showScore = false
    @State private var showFinalScore = false
    
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var question: Int = 1
    
    @State private var selectedFlag: Int? = nil
    @State private var rotationAmount = 0.0
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left and right stripes green, middle stripe white.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top and bottom stripes red, wider middle stripe yellow with coat of arms.",
        "UK": "Flag with overlapping red and white crosses on a blue background (Union Jack).",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with 13 horizontal stripes alternating red and white, and a blue rectangle with white stars in the top left corner."
    ]
    
    func resetGame() {
        score = 0
        question = 1
        askQuestion()
    }
    
    func flagTapped(_ number: Int) {
        withAnimation {
            selectedFlag = number
            rotationAmount += 360
        }
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }
        
        if question == 8 {
            // Final question → show final score alert
            showFinalScore = true
        } else {
            // Show regular score alert
            showScore = true
        }
        
        question += 1
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
        rotationAmount = 0.0
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                .rotation3DEffect(
                                    .degrees(selectedFlag == number ? rotationAmount : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(selectedFlag == nil || selectedFlag == number ? 1.0 : 0.25)
                                .scaleEffect(selectedFlag == nil || selectedFlag == number ? 1.0 : 0.7)
                        }
                        .accessibilityLabel(labels[countries[number], default: "Unkown Flag"])
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 100))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
        // Regular Question Alert
        .alert(scoreTitle, isPresented: $showScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreTitle == "Correct" ? "You got it right!" : "Nope, try again!")
        }
        
        // Final Score Alert
        .alert("Game Over", isPresented: $showFinalScore) {
            Button("Restart Game", action: resetGame)
        } message: {
            Text("Your final score is \(score) out of 8")
        }
    }
}

#Preview {
    ContentView()
}
