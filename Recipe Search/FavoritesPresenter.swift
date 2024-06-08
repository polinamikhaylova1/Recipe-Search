import CoreData

class FavoritesPresenter {
    
    weak var view: FavoritesView?
    
    init(view: FavoritesView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchFavorites()
    }
    
    private func fetchFavorites() {
            let context = CoreDataStack.shared.context
            let fetchRequest: NSFetchRequest<FavoriteRecipies> = FavoriteRecipies.fetchRequest()
            
            do {
                let favoriteRecipes = try context.fetch(fetchRequest)
                let recipes = favoriteRecipes.map { favoriteRecipe in
                    return RecipeModel(
                        label: favoriteRecipe.label ?? "",
                        image: favoriteRecipe.image ?? "",
                        ingredients: favoriteRecipe.ingredients ?? "",
                        totalTime: favoriteRecipe.totalTime
                    )
                }
                view?.showRecipes(recipes)
            } catch {
                view?.showError("Failed to fetch favorite recipes.")
            }
        }
    func deleteRecipe(_ recipe: RecipeModel) {
        CoreDataStack.shared.deleteFromFavorites(recipe: recipe)
        fetchFavorites()
    }
}

