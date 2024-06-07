import Foundation

struct Recipe: Decodable {
    let label: String
    let image: URL
    let ingredients: [Ingredient]
    //let calories: Double
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct RecipesResponse: Decodable {
    let hits: [Hit]
}

struct Ingredient: Decodable {
    let text: String
//    let weight: Double?
}

