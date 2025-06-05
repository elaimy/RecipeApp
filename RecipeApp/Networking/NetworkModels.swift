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

/// API Endpoints for Spoonacular
enum APIEndpoint {
    // Recipes
    case randomRecipes(number: Int)
    case recipeInformation(id: Int)
    case searchRecipes(query: String, number: Int)
    case complexSearch(query: String, cuisine: String?, diet: String?, intolerances: String?, number: Int)
    
    // Categories
    case cuisines
    case diets
    case mealTypes
    case dishTypes
    
    // Others
    case similarRecipes(id: Int, number: Int)
    case recipesByIngredients(ingredients: String, number: Int)
    case recipesByNutrients(minCarbs: Int?, maxCarbs: Int?, number: Int)
    
    var path: String {
        switch self {
        case .randomRecipes:
            return "recipes/random"
        case .recipeInformation(let id):
            return "recipes/\(id)/information"
        case .searchRecipes:
            return "recipes/complexSearch"
        case .complexSearch:
            return "recipes/complexSearch"
        case .cuisines:
            return "recipes/cuisines"
        case .diets:
            return "recipes/diets"
        case .mealTypes:
            return "recipes/mealTypes"
        case .dishTypes:
            return "recipes/dishTypes"
        case .similarRecipes(let id, _):
            return "recipes/\(id)/similar"
        case .recipesByIngredients:
            return "recipes/findByIngredients"
        case .recipesByNutrients:
            return "recipes/findByNutrients"
        }
    }
    
    var queryItems: [URLQueryItem] {
        // Always include the API key
        var items: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: NetworkConfig.apiKey)
        ]
        
        // Add endpoint-specific parameters
        switch self {
        case .randomRecipes(let number):
            items.append(URLQueryItem(name: "number", value: "\(number)"))
            
        case .recipeInformation:
            // Path already includes the ID
            break
            
        case .searchRecipes(let query, let number):
            items.append(URLQueryItem(name: "query", value: query))
            items.append(URLQueryItem(name: "number", value: "\(number)"))
            
        case .complexSearch(let query, let cuisine, let diet, let intolerances, let number):
            items.append(URLQueryItem(name: "query", value: query))
            items.append(URLQueryItem(name: "number", value: "\(number)"))
            
            if let cuisine = cuisine {
                items.append(URLQueryItem(name: "cuisine", value: cuisine))
            }
            
            if let diet = diet {
                items.append(URLQueryItem(name: "diet", value: diet))
            }
            
            if let intolerances = intolerances {
                items.append(URLQueryItem(name: "intolerances", value: intolerances))
            }
            
        case .cuisines, .diets, .mealTypes, .dishTypes:
            // No additional parameters needed
            break
            
        case .similarRecipes(_, let number):
            items.append(URLQueryItem(name: "number", value: "\(number)"))
            
        case .recipesByIngredients(let ingredients, let number):
            items.append(URLQueryItem(name: "ingredients", value: ingredients))
            items.append(URLQueryItem(name: "number", value: "\(number)"))
            
        case .recipesByNutrients(let minCarbs, let maxCarbs, let number):
            items.append(URLQueryItem(name: "number", value: "\(number)"))
            
            if let minCarbs = minCarbs {
                items.append(URLQueryItem(name: "minCarbs", value: "\(minCarbs)"))
            }
            
            if let maxCarbs = maxCarbs {
                items.append(URLQueryItem(name: "maxCarbs", value: "\(maxCarbs)"))
            }
        }
        
        return items
    }
}

/// HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Network Configuration for Spoonacular
struct NetworkConfig {
    static let baseURL = "https://api.spoonacular.com/"
    static let apiKey = "36edf57ccc0249c68fae2483dadafabc"
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
} 