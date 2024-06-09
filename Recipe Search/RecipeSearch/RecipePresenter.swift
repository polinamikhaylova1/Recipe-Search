import Foundation
import CoreData

protocol RecipePresenterProtocol: AnyObject {
    func searchRecipes(query: String, diet: String, health: String, cuisineType: String, mealType: String, dishType: String)
    func setView(view: RecipeViewProtocol)
    func didSelectRecipe(_ recipe: Recipe, at index: Int)
}

final class RecipePresenter: RecipePresenterProtocol {
    private weak var view: RecipeViewProtocol?
    private var recipes: [Recipe] = []
    private let recipeService: RecipeServiceProtocol
    let repository = RecipesRepository.shared
    
    init(view: RecipeViewProtocol?, recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    func searchRecipes(query: String, diet: String, health: String, cuisineType: String, mealType: String, dishType: String) {
        recipeService.fetchRecipes(query: query, diet: diet, health: health, cuisineType: cuisineType, mealType: mealType, dishType: dishType ) { [weak self] result in
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

