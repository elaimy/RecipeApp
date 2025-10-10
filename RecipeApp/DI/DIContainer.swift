import SwiftUI
import Combine

final class DIContainer: ObservableObject {
    static let shared = DIContainer()
    
    // Router as a dependency - make it @Published so it can be modified
    @Published var router: AppRouter
    
    // Network layer
    let networkService: NetworkServiceProtocol
    let apiClient: APIClientProtocol
    let recipeRepository: RecipeRepositoryProtocol
    
    // Favorites store
    let favoritesStore: FavoritesStore
    
    private init() {
        // Create a new router with default state
        self.router = AppRouter()
        
        // Initialize network layer
        self.networkService = NetworkService()
        self.apiClient = APIClient(networkService: self.networkService)
        self.recipeRepository = RecipeRepository(apiClient: self.apiClient)
        
        // Initialize favorites store
        self.favoritesStore = FavoritesStore(repository: self.recipeRepository)
        
        // Reset to welcome screen on init to ensure correct initial state
        self.router.currentScreen = .welcome
    }
    
    // MARK: - ViewModel Factories
    
    @MainActor func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(repository: recipeRepository)
    }
    
    @MainActor func makeMealsListViewModel(category: String) -> MealsListViewModel {
        return MealsListViewModel(repository: recipeRepository, category: category)
    }
    
    @MainActor func makeMealsListViewModel(ingredient: String) -> MealsListViewModel {
        return MealsListViewModel(repository: recipeRepository, ingredient: ingredient)
    }
    
    @MainActor func makeMealDetailViewModel(mealId: String) -> MealDetailViewModel {
        return MealDetailViewModel(repository: recipeRepository, mealId: mealId)
    }
    
    // Add a public initializer for previews
    static func preview() -> DIContainer {
        let container = DIContainer.shared
        return container
    }
} 
