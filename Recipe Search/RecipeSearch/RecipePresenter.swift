import Foundation
import CoreData

protocol RecipePresenterProtocol: AnyObject {
    func searchRecipes(query: String, mealType: String)
    func setView(view: RecipeViewProtocol)
    func didSelectRecipe(_ recipe: Recipe, at index: Int)
}

class RecipePresenter: RecipePresenterProtocol {
    private weak var view: RecipeViewProtocol?
    private var recipes: [Recipe] = []
    private let recipeService: RecipeServiceProtocol
    let repository = RecipesRepository.shared
    
    init(view: RecipeViewProtocol?, recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    func searchRecipes( query: String, mealType: String) {
        recipeService.fetchRecipes(query: query, mealType: mealType) { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.repository.saveRecipes(recipes)
                self?.view?.displayRecipes(recipes)
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }
    func setView(view: RecipeViewProtocol) {
        self.view = view
    }
    
    func didSelectRecipe(_ recipe: Recipe, at index: Int) {
        view?.navigateToDetailViewController(with: recipe, at: index)
        
    }
    
}

