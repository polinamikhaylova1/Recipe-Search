import Foundation

protocol RecipeDetailPresenterProtocol: AnyObject {
    func buttonTapped()
    func didLoad(view: RecipeDetailViewProtocol)
}

final class RecipeDetailPresenter: RecipeDetailPresenterProtocol {
    private weak var view: RecipeDetailViewProtocol?
    private let recipe: Recipe
    private let coreDataStack: CoreDataStack
    
    init(view: RecipeDetailViewProtocol?, recipe: Recipe, coreDataStack: CoreDataStack = .shared) {
        self.view = view
        self.recipe = recipe
        self.coreDataStack = coreDataStack
    }
    
    func didLoad(view: RecipeDetailViewProtocol) {
        self.view = view
        view.setTitle(recipe.label)
        view.setImage(url: recipe.image)
        view.setNutrients("Белки: \(recipe.totalNutrients.protein.quantity) г, Жиры: \(recipe.totalNutrients.fat.quantity) г, Углеводы: \(recipe.totalNutrients.carbs.quantity) г")
        view.setIngredients("Ингредиенты: " + recipe.ingredients.joined(separator: ", "))
    }
    
    func buttonTapped() {
        let context = coreDataStack.context
        let entity = RecipeEntity(context: context)
        entity.label = recipe.label
        entity.imageURL = recipe.image.absoluteString
        entity.ingredients = recipe.ingredients
        entity.protein = recipe.totalNutrients.protein.quantity
        entity.fat = recipe.totalNutrients.fat.quantity
        entity.carbs = recipe.totalNutrients.carbs.quantity
        
        do {
            try context.save()
            view?.displaySuccessMessage("Рецепт добавлен в избранное!")
        } catch {
            view?.displayErrorMessage("Не удалось сохранить рецепт")
        }
    }
}

