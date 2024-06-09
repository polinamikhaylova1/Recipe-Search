import Foundation

protocol RecipeDetailPresenterProtocol: AnyObject {
    func buttonTapped()
    func didLoad(view: RecipeDetailViewProtocol)
}

final class RecipeDetailPresenter: RecipeDetailPresenterProtocol {
    private weak var view: RecipeDetailViewProtocol?
    private let recipe: Recipe
    private let coreDataStack: CoreDataStack
    private let repository = RecipesRepository.shared
    private var recipeIndex: Int
    
    init(view: RecipeDetailViewProtocol?, recipe: Recipe, coreDataStack: CoreDataStack = .shared, recipeIndex: Int) {
        self.recipe = recipe
        self.recipeIndex = recipeIndex
        self.coreDataStack = coreDataStack
    }
    
    func didLoad(view: RecipeDetailViewProtocol) {
        self.view = view
        guard let recipe = repository.getRecipe(at: recipeIndex) else {
            return}
        
        view.setTitle(recipe.label)
        view.setImage(url: recipe.image)
        view.setIngredients(recipe.ingredients)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1

        let nutrientTexts = recipe.totalNutrients.compactMap { nutrient -> String? in
            guard let formattedQuantity = numberFormatter.string(from: NSNumber(value: nutrient.value.quantity)) else {
                return nil
            }
            return "\(nutrient.value.label): \(formattedQuantity) \(nutrient.value.unit)"
        }
        
        view.setTotalNutrients(nutrientTexts)
        view.updateContentSize()
    }
    
    func buttonTapped() {
        RecipesRepository.shared.saveToFavorites(recipe: recipe)
    }
    
}

