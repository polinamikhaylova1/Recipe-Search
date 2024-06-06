import Foundation



protocol RecipeDetailViewProtocol: AnyObject {
    func displaySuccessMessage(_ message: String)
    func displayErrorMessage(_ message: String)
    func setTitle(_ title: String)
    func setImage(url: URL)
    func setNutrients(_ nutrients: String)
    func setIngredients(_ ingredients: String)
}

