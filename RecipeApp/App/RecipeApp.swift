import SwiftUI

@main
struct RecipeApp: App {
    // Use StateObject to ensure a single instance of DIContainer
    @StateObject private var diContainer = DIContainer.shared
    
    // Initialize and register fonts
    init() {
        // Register custom fonts
        FontRegistration.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(diContainer)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var diContainer: DIContainer
    @ObservedObject private var router: AppRouter
    
    init() {
        // Get the router from the DIContainer to ensure we're using the same instance
        self._router = ObservedObject(wrappedValue: DIContainer.shared.router)
    }
    
    var body: some View {
        Group {
            switch router.currentScreen {
            case .welcome:
                WelcomeScreen()
                    .transition(.opacity)
            case .mainTab:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: router.currentScreen)
    }
} 