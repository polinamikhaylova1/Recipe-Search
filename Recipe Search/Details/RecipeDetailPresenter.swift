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
        let nutrientTexts = recipe.totalNutrients.map { "\($0.value.label): \($0.value.quantity) \($0.value.unit)" }
        view.setTotalNutrients(nutrientTexts)
        view.updateContentSize()
    }
    
    func buttonTapped() {
        RecipesRepository.shared.saveToFavorites(recipe: recipe)
    }
    
}

