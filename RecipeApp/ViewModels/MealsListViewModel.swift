import Foundation
import SwiftUI

@MainActor
final class MealsListViewModel: ObservableObject {
    @Published var meals: [MealSummaryDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol
    private let filterType: FilterType
    
    enum FilterType {
        case category(String)
        case ingredient(String)
        
        var displayName: String {
            switch self {
            case .category(let name), .ingredient(let name):
                return name
            }
        }
    }
    
    init(repository: RecipeRepositoryProtocol, filterType: FilterType) {
        self.repository = repository
        self.filterType = filterType
    }
    
    // Convenience initializers
    convenience init(repository: RecipeRepositoryProtocol, category: String) {
        self.init(repository: repository, filterType: .category(category))
    }
    
    convenience init(repository: RecipeRepositoryProtocol, ingredient: String) {
        self.init(repository: repository, filterType: .ingredient(ingredient))
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: FilterResponse
            switch filterType {
            case .category(let category):
                response = try await repository.getMealsByCategory(category: category)
            case .ingredient(let ingredient):
                response = try await repository.getMealsByIngredient(ingredient: ingredient)
            }
            
            meals = response.meals ?? []
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to load meals: \(error.localizedDescription)"
        }
    }
    
    func retry() async {
        await load()
    }
}

