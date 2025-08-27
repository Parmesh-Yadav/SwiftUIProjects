//
//  ContentView.swift
//  WordScramble
//
//  Created by Parmesh Yadav on 22/08/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage =  ""
    @State private var isShowingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                                
                            Text(word)
                        }
                    }
                }
                Section {
                    Text("Score: \(score)")
                        .font(.headline)
                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action:startGame) {
                        Label("Restart", systemImage: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action:startGame) {
                        Label("Restart", systemImage: "arrow.clockwise")
                    }
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $isShowingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        
        guard isValid(answer) else {
            wordError("Invalid word", "Word is either too small or exactly the same as the root word")
            return
        }
        
        guard isOriginal(answer) else {
            wordError("Word already used", "Be more original")
            return
        }
        
        guard isPossible(answer) else {
            wordError("Word not possible", "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(answer) else {
            wordError("Word not recognized", "You can't just make them up")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
            score += answer.count
        }
        newWord = ""
    }
    
    func startGame() {
        score = 0
        usedWords.removeAll()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                let allWords =  startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(_ word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(_ word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true;
    }
    
    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isValid(_ word: String) -> Bool {
        return !(word.count < 3 || word == rootWord)
    }
    
    func wordError(_ title: String, _ message: String) {
        errorTitle = title
        errorMessage = message
        isShowingError = true
    }
    
    func resetGame() {
        
    }
}

#Preview {
    ContentView()
}
