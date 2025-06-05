//
//  ColorManager.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import SwiftUI

/// Manages app-wide color schemes
struct ColorManager {
    // MARK: - Main Colors
    
    /// Primary brand color
    static let primary = Color("Primary")
    
    /// Secondary brand color
    static let secondary = Color("Secondary")
    
    /// White color
    static let white = Color("White")
    
    /// Black color
    static let black = Color("Black")
    
    /// TextSecondary color
    static let textSecondary = Color("TextSecondary")
    
    /// Icon color used when a tab is inactive
    static let inactiveIcon = Color("InActiveIcon")
        
    
    // MARK: - Dynamic Colors
    
    /// Gets color that adapts to light/dark mode based on a base color
    static func adaptive(light: Color, dark: Color) -> Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        return light
        #endif
    }
}

// MARK: - Color Extensions

extension Color {
    /// Initializes a color from hex value
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


