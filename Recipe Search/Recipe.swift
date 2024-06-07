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
class RecipesRepository {
    static let shared = RecipesRepository()
    private var recipes: [Recipe] = []
    
    private init() {}
    
    func saveRecipes(_ recipes: [Recipe]) {
        self.recipes = recipes
    }
    
    func getRecipes() -> [Recipe] {
        return recipes
    }
    
    func getRecipe(at index: Int) -> Recipe? {
        guard index >= 0 && index < recipes.count else {
            return nil
        }
        return recipes[index]
    }
}
