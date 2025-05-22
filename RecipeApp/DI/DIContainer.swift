import SwiftUI
import Combine

final class DIContainer: ObservableObject {
    static let shared = DIContainer()
    
    // Router as a dependency - make it @Published so it can be modified
    @Published var router: AppRouter
    
    private init() {
        // Create a new router with default state
        self.router = AppRouter()
        
        // Reset to welcome screen on init to ensure correct initial state
        self.router.currentScreen = .welcome
    }
    
    // Add a public initializer for previews
    static func preview() -> DIContainer {
        let container = DIContainer.shared
        return container
    }
} 
