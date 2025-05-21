//
//  FontRegistration.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import Foundation
import SwiftUI

/// Handles font registration to make custom fonts available in the app
class FontRegistration {
    /// Registers all custom fonts for the app
    static func registerFonts() {
        // List of fonts to register
        let fontNames = [
            "Rubik-Regular",
            "Rubik-Medium", 
            "Rubik-SemiBold",
            "Rubik-Bold",
            "Rubik-Black"
        ]
        
        // Register each font
        for fontName in fontNames {
            registerFont(fontName: fontName)
        }
    }
    
    /// Registers a single font with the system
    private static func registerFont(fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf"),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("⚠️ Failed to register font: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription = error?.takeUnretainedValue().localizedDescription ?? "unknown error"
            print("⚠️ Failed to register font: \(fontName). Error: \(errorDescription)")
        } else {
            print("✅ Successfully registered font: \(fontName)")
        }
    }
}

// MARK: - Font Loading Extensions

extension UIFont {
    /// Displays all available font names in the console
    static func listAllFonts() {
        for family in UIFont.familyNames.sorted() {
            print("Font Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted() {
                print("  - \(name)")
            }
        }
    }
}

// MARK: - View Extensions

extension View {
    /// Registers custom fonts when this view appears
    func registerCustomFonts() -> some View {
        self.onAppear {
            FontRegistration.registerFonts()
        }
    }
} 