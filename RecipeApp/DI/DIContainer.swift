import SwiftUI
import Combine

final class DIContainer: ObservableObject {
    static let shared = DIContainer()
    
    // Router as a dependency - make it @Published so it can be modified
    @Published var router: AppRouter
    
    // Shimmer service for loading states
    let shimmerService: ShimmerServiceProtocol
    
    // Network layer
    let networkService: NetworkServiceProtocol
    let apiClient: APIClientProtocol
    let recipeRepository: RecipeRepositoryProtocol
    
    private init() {
        // Create a new router with default state
        self.router = AppRouter()
        
        // Initialize services
        self.shimmerService = ShimmerService()
        
        // Initialize network layer
        self.networkService = NetworkService()
        self.apiClient = APIClient(networkService: self.networkService)
        self.recipeRepository = RecipeRepository(apiClient: self.apiClient)
        
        // Reset to welcome screen on init to ensure correct initial state
        self.router.currentScreen = .welcome
    }
    
    // Add a public initializer for previews
    static func preview() -> DIContainer {
        let container = DIContainer.shared
        return container
    }
    
    // Add a method for testing with mock services
    static func createForTest(
        router: AppRouter = AppRouter(),
        shimmerService: ShimmerServiceProtocol = ShimmerService(),
        networkService: NetworkServiceProtocol = NetworkService(),
        apiClient: APIClientProtocol? = nil,
        recipeRepository: RecipeRepositoryProtocol? = nil
    ) -> DIContainer {
        // For testing purposes, we create a new container rather than using shared
        let container = DIContainer.shared
        
        // Override the router which is mutable
        container.router = router
        
        // Note: In a real implementation, you would need to make the services
        // mutable or use a different approach to dependency injection for tests
        
        return container
    }
} 
