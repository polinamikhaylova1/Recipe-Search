import Foundation

protocol FavoritesDetailsPresenterProtocol: AnyObject {
    func buttonTapped()
    func didLoad(view: FavoritesDetailsViewProtocol)
}

final class FavoritesDetailsPresenter: FavoritesDetailsPresenterProtocol {
    private weak var view: FavoritesDetailsViewProtocol?
    private let recipe: RecipeModel
    private let coreDataStack: CoreDataStack
    private let repository = RecipesRepository.shared
    
    init(view: FavoritesDetailsViewProtocol?, recipe: RecipeModel, coreDataStack: CoreDataStack = .shared) {
        self.recipe = recipe

        self.coreDataStack = coreDataStack
    }
    
    func didLoad(view: FavoritesDetailsViewProtocol) {
        self.view = view
    
        view.setTitle(recipe.label)
        view.setImage(urlString: recipe.image)
        view.setIngredients(recipe.ingredients)
        //let nutrientTexts = recipe.totalNutrients.map { "\($0.value.label): \($0.value.quantity) \($0.value.unit)" }
        //view.setTotalNutrients(nutrientTexts)
        view.updateContentSize()
    }
    
    func buttonTapped() {
       //RecipesRepository.shared.saveToFavorites(recipe: recipe)
    }
    
}
