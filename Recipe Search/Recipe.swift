import Foundation

struct Recipe: Decodable {
    let label: String
    let image: URL
    let ingredients: [Ingredient]
    let calories: Double?
    let totalNutrients: Nutrients
    
    struct Nutrients: Decodable {
        let protein: Nutrient
        let fat: Nutrient
        let carbs: Nutrient
        
        struct Nutrient: Decodable {
            let quantity: Double
        }
    }
    var ingredientLines: [String] {
            return ingredients.map { $0.text }
        }
}

struct RecipeResponse: Decodable {
    let from: Int
    let to: Int
    let count: Int
    let hits: [Hit]
    
    
}
struct Hit: Decodable {
    let recipe: Recipe
}
struct Ingredient: Codable {
    let text: String
    let weight: Double?
}

