import Foundation

protocol RecipePresenterProtocol: AnyObject {
    func searchRecipes(query: String)
    func loadRecipesFromCoreData()
}

protocol RecipeViewProtocol: AnyObject {
    func displayRecipes(_ recipes: [Recipe])
    func displayError(_ error: Error)
}

