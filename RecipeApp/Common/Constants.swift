//
//  Constants.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import Foundation

/// App-wide constants
enum Constants {
    /// API related constants
    enum API {
        static let baseURL = "https://api.example.com/v1"
        static let timeout: TimeInterval = 30.0
    }
    
    /// UI related constants
    enum UI {
        static let cornerRadius: CGFloat = 10.0
        static let standardPadding: CGFloat = 16.0
        
        // Button related constants
        static let buttonHeight: CGFloat = 52.0
        static let buttonCornerRadius: CGFloat = 12.0
        static let buttonHorizontalPadding: CGFloat = 24.0
    }
    
    /// Storage keys
    enum StorageKeys {
        static let userToken = "user_token"
        static let favorites = "favorite_recipes"
    }
} 