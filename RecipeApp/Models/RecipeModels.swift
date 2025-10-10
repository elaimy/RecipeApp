import Foundation

// MARK: - Categories Response

struct CategoriesResponse: Codable {
    let categories: [CategoryDTO]
}

struct CategoryDTO: Codable, Identifiable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String?
    
    var id: String { idCategory }
}

// MARK: - Meals Filter Response

struct FilterResponse: Codable {
    let meals: [MealSummaryDTO]?
}

struct MealSummaryDTO: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
    
    var id: String { idMeal }
}

// MARK: - Ingredients List Response

struct IngredientsListResponse: Codable {
    let meals: [IngredientDTO]?
}

struct IngredientDTO: Codable, Identifiable {
    let idIngredient: String
    let strIngredient: String
    let strDescription: String?
    let strType: String?
    
    var id: String { idIngredient }
    
    var imageURL: String {
        "https://www.themealdb.com/images/ingredients/\(strIngredient).png"
    }
}

// MARK: - Meal Detail Response

struct DetailResponse: Codable {
    let meals: [MealDetailDTO]?
}

struct MealDetailDTO: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    let strYoutube: String?
    
    // Ingredients (up to 20)
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    
    // Measures (up to 20)
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    
    let strSource: String?
    let strImageSource: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
    
    var id: String { idMeal }
    
    // Helper computed property to get ingredients with measures
    var ingredients: [(ingredient: String, measure: String)] {
        let allIngredients = [
            (strIngredient1, strMeasure1),
            (strIngredient2, strMeasure2),
            (strIngredient3, strMeasure3),
            (strIngredient4, strMeasure4),
            (strIngredient5, strMeasure5),
            (strIngredient6, strMeasure6),
            (strIngredient7, strMeasure7),
            (strIngredient8, strMeasure8),
            (strIngredient9, strMeasure9),
            (strIngredient10, strMeasure10),
            (strIngredient11, strMeasure11),
            (strIngredient12, strMeasure12),
            (strIngredient13, strMeasure13),
            (strIngredient14, strMeasure14),
            (strIngredient15, strMeasure15),
            (strIngredient16, strMeasure16),
            (strIngredient17, strMeasure17),
            (strIngredient18, strMeasure18),
            (strIngredient19, strMeasure19),
            (strIngredient20, strMeasure20)
        ]
        
        return allIngredients.compactMap { ingredient, measure in
            guard let ing = ingredient?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !ing.isEmpty else { return nil }
            let meas = measure?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return (ing, meas)
        }
    }
}

