import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    // Section data
    @Published var categories: [CategoryDTO] = []
    @Published var topMeals: [MealSummaryDTO] = []
    @Published var chefsPicks: [MealSummaryDTO] = []
    @Published var ingredients: [IngredientDTO] = []
    
    // Loading states per section
    @Published var isLoadingTopDishes = false
    @Published var isLoadingCategories = false
    @Published var isLoadingChefsPicks = false
    @Published var isLoadingIngredients = false
    
    // Error states per section
    @Published var topDishesError: String?
    @Published var categoriesError: String?
    @Published var chefsPicksError: String?
    @Published var ingredientsError: String?
    
    private let repository: RecipeRepositoryProtocol
    
    // Placeholder counts
    private let topDishesPlaceholderCount = 10
    private let categoriesPlaceholderCount = 12
    private let chefsPicksPlaceholderCount = 10
    private let ingredientsPlaceholderCount = 10
    
    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }
    
    var topDishesPlaceholders: [Int] {
        Array(0..<topDishesPlaceholderCount)
    }
    
    var categoriesPlaceholders: [Int] {
        Array(0..<categoriesPlaceholderCount)
    }
    
    var chefsPicksPlaceholders: [Int] {
        Array(0..<chefsPicksPlaceholderCount)
    }
    
    var ingredientsPlaceholders: [Int] {
        Array(0..<ingredientsPlaceholderCount)
    }
    
    func load() async {
        // Launch all sections concurrently
        async let categoriesTask: () = loadCategories()
        async let chefsPicksTask: () = loadChefsPicks()
        async let ingredientsTask: () = loadIngredients()
        
        // Wait for categories first to get Top Dishes category
        await categoriesTask
        await loadTopDishes()
        
        // Wait for remaining tasks
        await chefsPicksTask
        await ingredientsTask
    }
    
    private func loadCategories() async {
        isLoadingCategories = true
        categoriesError = nil
        
        do {
            let response: CategoriesResponse = try await repository.getCategories()
            categories = Array(response.categories.prefix(categoriesPlaceholderCount))
            isLoadingCategories = false
        } catch {
            isLoadingCategories = false
            categoriesError = "Failed to load categories"
        }
    }
    
    private func loadTopDishes() async {
        isLoadingTopDishes = true
        topDishesError = nil
        
        do {
            let firstCategory = categories.first?.strCategory ?? "Beef"
            let response: FilterResponse = try await repository.getMealsByCategory(category: firstCategory)
            topMeals = Array((response.meals ?? []).prefix(topDishesPlaceholderCount))
            isLoadingTopDishes = false
        } catch {
            isLoadingTopDishes = false
            topDishesError = "Failed to load top dishes"
        }
    }
    
    private func loadChefsPicks() async {
        isLoadingChefsPicks = true
        chefsPicksError = nil
        
        do {
            // Fetch multiple random meals concurrently
            var uniqueMeals: [String: MealSummaryDTO] = [:]
            
            // Fetch up to 15 random meals to ensure we get 10 unique ones
            await withTaskGroup(of: MealSummaryDTO?.self) { group in
                for _ in 0..<15 {
                    group.addTask { [weak self] in
                        guard let self = self else { return nil }
                        do {
                            let response: DetailResponse = try await self.repository.getRandomMeal()
                            if let meal = response.meals?.first {
                                return MealSummaryDTO(
                                    idMeal: meal.idMeal,
                                    strMeal: meal.strMeal,
                                    strMealThumb: meal.strMealThumb
                                )
                            }
                        } catch {}
                        return nil
                    }
                }
                
                for await meal in group {
                    if let meal = meal {
                        uniqueMeals[meal.idMeal] = meal
                        if uniqueMeals.count >= chefsPicksPlaceholderCount {
                            break
                        }
                    }
                }
            }
            
            chefsPicks = Array(uniqueMeals.values.prefix(chefsPicksPlaceholderCount))
            isLoadingChefsPicks = false
        } catch {
            isLoadingChefsPicks = false
            chefsPicksError = "Failed to load chef's picks"
        }
    }
    
    private func loadIngredients() async {
        isLoadingIngredients = true
        ingredientsError = nil
        
        do {
            let response: IngredientsListResponse = try await repository.getIngredientsList()
            
            // Curated list of popular ingredients
            let popularIngredients = [
                "Chicken", "Beef", "Salmon", "Pork", "Eggs",
                "Tomatoes", "Onions", "Garlic", "Cheese", "Mushrooms"
            ]
            
            let allIngredients = response.meals ?? []
            let filtered = allIngredients.filter { ingredient in
                popularIngredients.contains(ingredient.strIngredient)
            }
            
            ingredients = Array(filtered.prefix(ingredientsPlaceholderCount))
            isLoadingIngredients = false
        } catch {
            isLoadingIngredients = false
            ingredientsError = "Failed to load ingredients"
        }
    }
    
    // Section-specific retry methods
    func retryCategories() async {
        await loadCategories()
    }
    
    func retryTopDishes() async {
        await loadTopDishes()
    }
    
    func retryChefsPicks() async {
        await loadChefsPicks()
    }
    
    func retryIngredients() async {
        await loadIngredients()
    }
}

