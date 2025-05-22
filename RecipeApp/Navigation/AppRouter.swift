//
//  AppRouter.swift
//  RecipeApp
//
//  Created by Ahmed Elelaimy
//

import Foundation
import SwiftUI
import Combine

final class AppRouter: ObservableObject {
    // Use NavigationPath for navigation
    @Published var navPath = NavigationPath()
    
    // Current screen state - explicitly initialize to .welcome
    @Published var currentScreen: AppScreen = .welcome
    
    // Screen destinations
    enum Destination: Hashable {
        case home
        case categories
        case favorites
        case profile
    }
    
    enum AppScreen {
        case welcome
        case mainTab
    }
    
    init() {
        // Initialize with welcome screen
    }
    
    func navigateToHome() {
        withAnimation {
            currentScreen = .mainTab
        }
    }
    
    func navigateToWelcome() {
        withAnimation {
            currentScreen = .welcome
        }
    }
    
    // For internal tab navigation
    func navigateToTab(_ destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateToRoot() {
        navPath = NavigationPath()
    }
}




