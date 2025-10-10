import Foundation

/// API Errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let statusCode, _):
            return "HTTP Error: \(statusCode)"
        case .decodingError:
            return "Failed to decode response"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

/// API Endpoints for TheMealDB
enum APIEndpoint {
    // Categories
    case categories
    
    // Meals
    case mealsByCategory(category: String)
    case mealsByIngredient(ingredient: String)
    case mealDetails(id: String)
    case searchMeals(query: String)
    case randomMeal
    
    // Ingredients
    case ingredientsList
    
    var path: String {
        switch self {
        case .categories:
            return "categories.php"
        case .mealsByCategory, .mealsByIngredient:
            return "filter.php"
        case .mealDetails:
            return "lookup.php"
        case .searchMeals:
            return "search.php"
        case .randomMeal:
            return "random.php"
        case .ingredientsList:
            return "list.php"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .categories, .randomMeal:
            return []
        case .mealsByCategory(let category):
            return [URLQueryItem(name: "c", value: category)]
        case .mealsByIngredient(let ingredient):
            return [URLQueryItem(name: "i", value: ingredient)]
        case .mealDetails(let id):
            return [URLQueryItem(name: "i", value: id)]
        case .searchMeals(let query):
            return [URLQueryItem(name: "s", value: query)]
        case .ingredientsList:
            return [URLQueryItem(name: "i", value: "list")]
        }
    }
}

/// HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Network Configuration for TheMealDB
struct NetworkConfig {
    static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
}

