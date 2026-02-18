import SwiftUI

/// Centralized theme values for the SwiftUI app.
enum AppTheme {
    static let primary = Color(hex: 0x3B82F6)     // #3b82f6
    static let secondary = Color(hex: 0x64748B)   // #64748b
    static let success = Color(hex: 0x06B6D4)     // #06b6d4
    static let error = Color(hex: 0xEF4444)       // #EF4444

    static let background = Color(hex: 0xF9FAFB)  // #f9fafb
    static let surface = Color.white              // #ffffff
    static let text = Color(hex: 0x111827)        // #111827

    static let backgroundGradient = LinearGradient(
        colors: [
            AppTheme.primary.opacity(0.10),
            Color(hex: 0xF9FAFB)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    /// Initializes a Color from a hex value like `0xRRGGBB`.
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8) / 255.0
        let b = Double(hex & 0x0000FF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
