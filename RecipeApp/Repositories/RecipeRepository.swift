import Foundation

/// Protocol defining the repository operations for recipes
protocol RecipeRepositoryProtocol {
    // Recipe operations
    func getRandomRecipes<T: Decodable>(number: Int) async throws -> T
    func getRecipeDetails<T: Decodable>(id: Int) async throws -> T
    func searchRecipes<T: Decodable>(query: String, number: Int) async throws -> T
    func complexSearch<T: Decodable>(query: String, cuisine: String?, diet: String?, intolerances: String?, number: Int) async throws -> T
    
    // Category operations
    func getCuisines<T: Decodable>() async throws -> T
    func getDiets<T: Decodable>() async throws -> T
    func getMealTypes<T: Decodable>() async throws -> T
    func getDishTypes<T: Decodable>() async throws -> T
    
    // Other operations
    func getSimilarRecipes<T: Decodable>(id: Int, number: Int) async throws -> T
    func getRecipesByIngredients<T: Decodable>(ingredients: String, number: Int) async throws -> T
    func getRecipesByNutrients<T: Decodable>(minCarbs: Int?, maxCarbs: Int?, number: Int) async throws -> T
}

/// Implementation of the recipe repository
final class RecipeRepository: RecipeRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Recipe Operations
    
    func getRandomRecipes<T: Decodable>(number: Int = 10) async throws -> T {
        return try await apiClient.getRandomRecipes(number: number)
    }
    
    func getRecipeDetails<T: Decodable>(id: Int) async throws -> T {
        return try await apiClient.getRecipeInformation(id: id)
    }
    
    func searchRecipes<T: Decodable>(query: String, number: Int = 10) async throws -> T {
        return try await apiClient.searchRecipes(query: query, number: number)
    }
    
    func complexSearch<T: Decodable>(query: String, cuisine: String? = nil, diet: String? = nil, intolerances: String? = nil, number: Int = 10) async throws -> T {
        return try await apiClient.complexSearch(query: query, cuisine: cuisine, diet: diet, intolerances: intolerances, number: number)
    }
    
    // MARK: - Category Operations
    
    func getCuisines<T: Decodable>() async throws -> T {
        return try await apiClient.getCuisines()
    }
    
    func getDiets<T: Decodable>() async throws -> T {
        return try await apiClient.getDiets()
    }
    
    func getMealTypes<T: Decodable>() async throws -> T {
        return try await apiClient.getMealTypes()
    }
    
    func getDishTypes<T: Decodable>() async throws -> T {
        return try await apiClient.getDishTypes()
    }
    
    // MARK: - Other Operations
    
    func getSimilarRecipes<T: Decodable>(id: Int, number: Int = 5) async throws -> T {
        return try await apiClient.getSimilarRecipes(id: id, number: number)
    }
    
    func getRecipesByIngredients<T: Decodable>(ingredients: String, number: Int = 10) async throws -> T {
        return try await apiClient.getRecipesByIngredients(ingredients: ingredients, number: number)
    }
    
    func getRecipesByNutrients<T: Decodable>(minCarbs: Int? = nil, maxCarbs: Int? = nil, number: Int = 10) async throws -> T {
        return try await apiClient.getRecipesByNutrients(minCarbs: minCarbs, maxCarbs: maxCarbs, number: number)
    }
} 