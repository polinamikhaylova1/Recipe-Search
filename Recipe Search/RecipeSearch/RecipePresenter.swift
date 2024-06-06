import Foundation
import CoreData

class RecipePresenter: RecipePresenterProtocol {
    private weak var view: RecipeViewProtocol?
    private let recipeService: RecipeServiceProtocol
    private let coreDataStack: CoreDataStack
    
    init(view: RecipeViewProtocol?, recipeService: RecipeServiceProtocol = RecipeService(), coreDataStack: CoreDataStack = .shared) {
        self.recipeService = recipeService
        self.coreDataStack = coreDataStack
    }
    
    func searchRecipes(query: String) {
        recipeService.fetchRecipes(query: query) { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.view?.displayRecipes(recipes)
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }
    
    func loadRecipesFromCoreData() {
            let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
            do {
                let entities = try coreDataStack.context.fetch(fetchRequest)
                let recipes = entities.map { entity -> Recipe in
                    let ingredients = entity.ingredients?.components(separatedBy: ", ") ?? []
                    return Recipe(
                        label: entity.label ?? "",
                        image: URL(string: entity.imageURL ?? "")!,
                        ingredients: ingredients.map { Ingredient(text: $0, weight: 3) },
                        calories: entity.calories,
                        totalNutrients: Recipe.Nutrients(
                            protein: Recipe.Nutrients.Nutrient(quantity: entity.protein),
                            fat: Recipe.Nutrients.Nutrient(quantity: entity.fat),
                            carbs: Recipe.Nutrients.Nutrient(quantity: entity.carbs)
                        )
                    )
                }
                view?.displayRecipes(recipes)
            } catch {
                view?.displayError(error)
            }
        }
    
}

