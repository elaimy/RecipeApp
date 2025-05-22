//
//  FontManager.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import SwiftUI

/// Font weights available for Rubik font
enum RubikFontWeight {
    case regular
    case medium
    case semiBold
    case bold
    case black
    
    /// Returns the appropriate font name for this weight
    var fontName: String {
        switch self {
        case .regular:
            return "Rubik-Regular"
        case .medium:
            return "Rubik-Medium"
        case .semiBold:
            return "Rubik-SemiBold"
        case .bold:
            return "Rubik-Bold"
        case .black:
            return "Rubik-Black"
        }
    }
}

/// Manages app-wide fonts
struct FontManager {
    /// Gets Rubik font with the specified size and weight
    static func rubik(size: CGFloat, weight: RubikFontWeight = .regular) -> Font {
        return Font.custom(weight.fontName, size: size)
    }
}

// MARK: - Font Extensions

extension View {
    /// Apply Rubik font with specific size and weight
    func rubikFont(size: CGFloat, weight: RubikFontWeight = .regular) -> some View {
        self.font(FontManager.rubik(size: size, weight: weight))
    }
    
    /// Apply Rubik regular font with specific size
    func rubikRegular(size: CGFloat) -> some View {
        self.font(FontManager.rubik(size: size, weight: .regular))
    }
    
    /// Apply Rubik medium font with specific size
    func rubikMedium(size: CGFloat) -> some View {
        self.font(FontManager.rubik(size: size, weight: .medium))
    }
    
    /// Apply Rubik semibold font with specific size
    func rubikSemiBold(size: CGFloat) -> some View {
        self.font(FontManager.rubik(size: size, weight: .semiBold))
    }
    
    /// Apply Rubik bold font with specific size
    func rubikBold(size: CGFloat) -> some View {
        self.font(FontManager.rubik(size: size, weight: .bold))
    }
    
    /// Apply Rubik black font with specific size
    func rubikBlack(size: CGFloat) -> some View {
        self.font(FontManager.rubik(size: size, weight: .black))
    }
} 