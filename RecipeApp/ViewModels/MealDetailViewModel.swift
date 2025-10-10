import Foundation
import SwiftUI

@MainActor
final class MealDetailViewModel: ObservableObject {
    @Published var meal: MealDetailDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: RecipeRepositoryProtocol
    private let mealId: String
    
    init(repository: RecipeRepositoryProtocol, mealId: String) {
        self.repository = repository
        self.mealId = mealId
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: DetailResponse = try await repository.getMealDetails(id: mealId)
            meal = response.meals?.first
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to load meal details: \(error.localizedDescription)"
        }
    }
    
    func retry() async {
        await load()
    }
}

