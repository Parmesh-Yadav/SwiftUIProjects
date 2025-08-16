//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Parmesh Yadav on 16/08/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ContentView: View {

    // --- GAME STATE (unchanged core) ---
    @State private var countries = ["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Spain","UK","Ukraine","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showScore = false
    @State private var showFinalScore = false

    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var question: Int = 1

    // --- UI/ANIMATION STATE (new) ---
    @State private var tappedIndex: Int? = nil
    @State private var animateSpin = false
    @State private var wrongShakeCount: Int = 0
    @State private var isPressing: Int? = nil
    @State private var animateBg: Bool = false

    // Subtle ambient glow that updates with each question
    private var accent: Color {
        let palette: [Color] = [
            .cyan, .mint, .purple, .pink, .blue, .teal, .indigo
        ]
        return palette[(question - 1) % palette.count]
    }

    // MARK: - Game Actions (logic preserved)
    func resetGame() {
        score = 0
        question = 1
        askQuestion()
        resetUI()
    }

    func flagTapped(_ number: Int) {
        tappedIndex = number

        #if canImport(UIKit)
        let h = UINotificationFeedbackGenerator()
        #endif

        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            animateSpin.toggle()

            #if canImport(UIKit)
            h.notificationOccurred(.success)
            #endif
        } else {
            scoreTitle = "Wrong"
            score -= 1
            wrongShakeCount += 1

            #if canImport(UIKit)
            h.notificationOccurred(.error)
            #endif
        }

        if question == 8 {
            showFinalScore = true
        } else {
            showScore = true
        }

        question += 1
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        resetUI()
    }

    private func resetUI() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            tappedIndex = nil
            isPressing = nil
        }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            // Animated, futuristic gradient background (one view, no assets)
            AnimatedFuturisticBackground(isAnimating: $animateBg, accent: accent)

            VStack(spacing: 24) {
                // Title Card
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(accent.opacity(0.7))
                            .frame(width: 10, height: 10)
                            .shadow(radius: 6)
                            .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
                        Text("Guess The Flag")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 10)
                    }

                    // Subheading with subtle capsule HUD
                    HUDChip(icon: "target", text: "Tap the flag of \(countries[correctAnswer])", accent: accent)
                        .accessibilityLabel("Tap the flag of \(countries[correctAnswer])")
                }
                .padding(.top, 8)

                // Cards Container (glassmorphism + neon rim)
                VStack(spacing: 18) {
                    ForEach(0..<3) { number in
                        FlagButton(
                            imageName: countries[number],
                            isCorrect: number == correctAnswer,
                            isTapped: tappedIndex == number,
                            dimOthers: tappedIndex != nil && tappedIndex != number,
                            wrongShakeCount: wrongShakeCount,
                            spinOnCorrect: animateSpin && tappedIndex == number && number == correctAnswer,
                            accent: accent
                        ) {
                            // Press / release feedback (scale on press)
                            isPressing = number
                        } onRelease: {
                            isPressing = nil
                            flagTapped(number)
                        }
                        .scaleEffect(isPressing == number ? 0.97 : 1.0)
                        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isPressing)
                        .accessibilityLabel(countries[number])
                        .accessibilityAddTraits(.isButton)
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            .linearGradient(colors: [accent.opacity(0.6), .white.opacity(0.15), accent.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1
                        )
                        .shadow(color: accent.opacity(0.25), radius: 16, x: 0, y: 6)
                )
                .shadow(color: .black.opacity(0.35), radius: 30, x: 0, y: 20)

                // Score HUD
                HStack(spacing: 16) {
                    HUDStat(icon: "number", label: "Q", value: "\(min(question, 8)) / 8")
                    HUDStat(icon: "star.fill", label: "Score", value: "\(score)")
                }
                .padding(.bottom, 8)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animateBg = true
            }
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

// MARK: - Subviews & Modifiers (single-file, reusable, minimalistic + futuristic)

/// Animated background with layered gradients + noise-like shimmer for depth
struct AnimatedFuturisticBackground: View {
    @Binding var isAnimating: Bool
    var accent: Color

    var body: some View {
        ZStack {
            // Deep space backdrop
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.02, green: 0.05, blue: 0.10),
                    Color(red: 0.03, green: 0.01, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Large, slow-moving angular gradient aura
            AngularGradient(
                gradient: Gradient(colors: [
                    accent.opacity(0.35),
                    .purple.opacity(0.25),
                    .blue.opacity(0.2),
                    accent.opacity(0.35)
                ]),
                center: .center
            )
            .blendMode(.screen)
            .scaleEffect(isAnimating ? 1.4 : 1.0)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 45).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .ignoresSafeArea()

            // Subtle moving radial bloom
            RadialGradient(
                colors: [accent.opacity(0.18), .clear],
                center: .init(x: 0.7, y: isAnimating ? 0.2 : 0.8),
                startRadius: 80,
                endRadius: 600
            )
            .blur(radius: 60)
            .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: isAnimating)
            .ignoresSafeArea()

            // Soft film grain for texture (no image; procedural via overlay)
            Rectangle()
                .fill(.white.opacity(0.015))
                .blendMode(.overlay)
                .mask(
                    LinearGradient(colors: [.black, .clear, .black], startPoint: .top, endPoint: .bottom)
                )
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }
    }
}

/// A glassy HUD chip for prompts
struct HUDChip: View {
    var icon: String
    var text: String
    var accent: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
                .padding(6)
                .background(accent.opacity(0.35), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(text)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial, in: Capsule(style: .continuous))
        .overlay(
            Capsule(style: .continuous)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 10)
    }
}

/// Minimal stat HUD block (score / questions)
struct HUDStat: View {
    var icon: String
    var label: String
    var value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .imageScale(.medium)
                .foregroundStyle(.white.opacity(0.85))
            VStack(alignment: .leading, spacing: 2) {
                Text(label.uppercased())
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.55))
                Text(value)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}

/// Flag button with futuristic styling, press feedback, correct spin, wrong shake, and dimming others
struct FlagButton: View {
    var imageName: String
    var isCorrect: Bool
    var isTapped: Bool
    var dimOthers: Bool
    var wrongShakeCount: Int
    var spinOnCorrect: Bool
    var accent: Color
    var onPress: () -> Void
    var onRelease: () -> Void

    // Shake animation for wrong answer
    @State private var shakePhase: CGFloat = 0

    var body: some View {
        Button {
            // noop—handled by gestures below to capture press vs release
        } label: {
            ZStack {
                // Neon outline glow (dynamic)
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.linearGradient(
                        colors: [accent.opacity(0.18), .white.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .strokeBorder(
                                .linearGradient(
                                    colors: [
                                        .white.opacity(0.35),
                                        accent.opacity(0.5),
                                        .white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: accent.opacity(isTapped ? 0.55 : 0.25), radius: isTapped ? 30 : 16, x: 0, y: 10)

                // Flag image
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(10)
                    .shadow(color: .black.opacity(0.45), radius: 12, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.15), lineWidth: 1)
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .modifier(DimAndBlur(isDimmed: dimOthers, amount: 0.5))
            .rotation3DEffect(.degrees(spinOnCorrect ? 360 : 0), axis: (x: 0, y: 1, z: 0))
            .animation(spinOnCorrect ? .spring(response: 0.6, dampingFraction: 0.7) : .default, value: spinOnCorrect)
            .modifier(ShakeEffect(animatableData: CGFloat(wrongShakeCount)))
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
        .accessibilityHint("Double tap to select this flag")
    }
}

// MARK: - Visual Modifiers

struct DimAndBlur: ViewModifier {
    var isDimmed: Bool
    var amount: Double
    func body(content: Content) -> some View {
        content
            .opacity(isDimmed ? 0.35 : 1.0)
            .blur(radius: isDimmed ? 1.5 : 0)
            .scaleEffect(isDimmed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.25), value: isDimmed)
    }
}

/// Classic shake effect (param = wrong attempt count)
struct ShakeEffect: GeometryEffect {
    var travel: CGFloat = 8
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = travel * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
