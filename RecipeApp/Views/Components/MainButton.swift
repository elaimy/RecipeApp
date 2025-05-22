//
//  MainButton.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import SwiftUI
import Foundation

/// A reusable main button component with consistent styling
struct MainButton: View {
    // MARK: - Properties
    
    /// The text to display on the button
    let title: String
    
    /// The action to perform when the button is tapped
    let action: () -> Void
    
    /// The background color of the button (defaults to primary color)
    var backgroundColor: Color?
    
    /// The text color (defaults to white)
    var textColor: Color = ColorManager.white
    
    /// Whether the button is disabled
    var isDisabled: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .rubikSemiBold(size: 18)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.UI.buttonHeight)
                .background(isDisabled ? ColorManager.primary.opacity(0.5) : backgroundColor ?? ColorManager.primary)
                .cornerRadius(Constants.UI.buttonCornerRadius)
                .padding(.horizontal, Constants.UI.buttonHorizontalPadding)
        }
        .disabled(isDisabled)
    }
}

// MARK: - Modifiers

extension MainButton {
    /// Sets the button's background color
    func withBackgroundColor(_ color: Color) -> MainButton {
        var button = self
        button.backgroundColor = color
        return button
    }
    
    /// Sets the button's text color
    func withTextColor(_ color: Color) -> MainButton {
        var button = self
        button.textColor = color
        return button
    }
    
    /// Sets whether the button is disabled
    func disabled(_ disabled: Bool) -> MainButton {
        var button = self
        button.isDisabled = disabled
        return button
    }
}

// MARK: - Preview

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MainButton(title: "Get Started", action: {})
            
            MainButton(title: "Continue", action: {})
                .withBackgroundColor(ColorManager.secondary)
            
            MainButton(title: "Disabled Button", action: {})
                .disabled(true)
            
            MainButton(title: "Custom Colors", action: {})
                .withBackgroundColor(.blue)
                .withTextColor(.yellow)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
} 