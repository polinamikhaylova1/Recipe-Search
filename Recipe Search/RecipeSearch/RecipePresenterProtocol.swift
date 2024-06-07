import Foundation

protocol RecipePresenterProtocol: AnyObject {
    func searchRecipes(query: String, mealType: String)
    func setView(view: RecipeViewProtocol)
    func didSelectRecipe(_ recipe: Recipe)
}

protocol RecipeViewProtocol: AnyObject {
    func displayRecipes(_ recipes: [Recipe])
    func displayError(_ error: Error)
    func navigateToDetailViewController(with recipe: Recipe)
}

