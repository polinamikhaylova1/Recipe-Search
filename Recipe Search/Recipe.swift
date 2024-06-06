import Foundation

struct Recipe: Decodable {
    let label: String
    let image: URL
    let ingredients: [String]
    let calories: Double
    let totalNutrients: Nutrients
    
    struct Nutrients: Decodable {
        let protein: Nutrient
        let fat: Nutrient
        let carbs: Nutrient
        
        struct Nutrient: Decodable {
            let quantity: Double
        }
    }
}

struct RecipeResponse: Decodable {
    let hits: [Hit]
    
    struct Hit: Decodable {
        let recipe: Recipe
    }
}

