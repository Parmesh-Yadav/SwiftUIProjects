import SwiftUI

// MARK: - Futuristic Theme Extensions
extension Color {
    static let neonBlue = Color(red: 0.0, green: 0.9, blue: 1.0)
    static let neonPurple = Color(red: 0.8, green: 0.0, blue: 1.0)
    static let deepSpace = Color(red: 0.05, green: 0.05, blue: 0.1)
    static let glass = Color.white.opacity(0.1)
}

extension View {
    func futuristicCard() -> some View {
        self
            .background(.ultraThinMaterial)
            .background(Color.deepSpace.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .neonBlue.opacity(0.2), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(LinearGradient(colors: [.neonBlue.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            )
    }
    
    func glowingText() -> some View {
        self.shadow(color: .neonBlue.opacity(0.8), radius: 8)
    }
}
