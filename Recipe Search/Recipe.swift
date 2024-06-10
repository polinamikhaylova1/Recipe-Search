import Foundation
import CoreData

struct Recipe: Decodable {
    let uri: String
    let label: String
    let image: String
    let url: String
    let ingredients: [Ingredient]
    let totalTime: Double
    let totalNutrients: [String: TotalNutrientDTO]
    let calories: Double
}

struct TotalNutrientDTO: Decodable {
    let label: String
    let quantity: Double
    let unit: String
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct RecipesResponse: Decodable {
    let hits: [Hit]
}

struct Ingredient: Decodable {
    let text: String
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
    func saveToFavorites(recipe: Recipe) {
        let context = CoreDataStack.shared.context
        let favoriteRecipe = NSEntityDescription.insertNewObject(forEntityName: "FavoriteRecipies", into: context) as! FavoriteRecipies
        favoriteRecipe.label = recipe.label
        favoriteRecipe.image = recipe.image
        favoriteRecipe.url = recipe.url
        favoriteRecipe.ingredients = recipe.ingredients.map { $0.text }.joined(separator: ", ")
        favoriteRecipe.uri = recipe.uri
        
        CoreDataStack.shared.saveContext()
    }
    
}
