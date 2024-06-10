import UIKit

protocol RecipeViewProtocol: AnyObject {
    func displayRecipes(_ recipes: [Recipe])
    func displayError(_ error: Error)
    func navigateToDetailViewController(with recipe: Recipe, at index: Int)
}

final class RecipeViewController: UIViewController {
    private var recipes: [Recipe] = []
    private let presenter: RecipePresenterProtocol
    private var recipeView = RecipeView()
    
    private var selectedCuisine: String? 
    private var selectedHealth: String?
    private var selectedDishType: String?
    private var selectedDiet: String?
    
    init(presenter: RecipePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        recipeView.searchBar.delegate = self
        recipeView.collectionView.delegate = self
        recipeView.collectionView.dataSource = self
        recipeView.mealTypeSegmentedControl.addTarget(self, action: #selector(mealTypeChanged(_:)), for: .valueChanged)
        recipeView.filterButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
        presenter.setView(view: self)
        title = "Search"
        performSearch()
    }
    
    override func loadView() {
        recipeView = RecipeView()
        self.view = recipeView
    }
    
    @objc private func mealTypeChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    @objc private func openFilter() {
        let filterViewController = FilterViewController()
        let filterPresenter = FilterPresenter(view: self)
        filterViewController.delegate = self
        filterViewController.modalPresentationStyle = .automatic
        present(filterViewController, animated: true, completion: nil)
    }
    
    
    private func performSearch() {
        guard let query = recipeView.searchBar.text, !query.isEmpty else {
            let defaultQuery = ""
            let mealTypes = ["Breakfast", "Brunch", "Dinner", "Snack"]
            let selectedMealTypeIndex = recipeView.mealTypeSegmentedControl.selectedSegmentIndex
            let selectedMealType: String
            if selectedMealTypeIndex >= 0 && selectedMealTypeIndex < mealTypes.count {
                selectedMealType = mealTypes[selectedMealTypeIndex]
            } else {
                selectedMealType = "Breakfast"
            }
            presenter.searchRecipes(
                query: defaultQuery,
                diet: selectedDiet ?? "balanced",
                health: selectedHealth ?? "alcohol-free",
                cuisineType: selectedCuisine ?? "American",
                mealType: selectedMealType,
                dishType: selectedDishType ?? "Main course"
            )
            print ("рецепты загружены")
            return
        }
        let mealTypes = ["Breakfast", "Brunch", "Dinner", "Snack"]
        let selectedMealTypeIndex = recipeView.mealTypeSegmentedControl.selectedSegmentIndex
        let selectedMealType: String
        if selectedMealTypeIndex >= 0 && selectedMealTypeIndex < mealTypes.count {
            selectedMealType = mealTypes[selectedMealTypeIndex]
        } else {
            selectedMealType = "Breakfast" 
        }
        presenter.searchRecipes(
            query: query,
            diet: selectedDiet ?? "balanced",
            health: selectedHealth ?? "alcohol-free",
            cuisineType: selectedCuisine ?? "American",
            mealType: selectedMealType,
            dishType: selectedDishType ?? "Main course"
        )
        
        print ("рецепты загружены")
    }
}

extension RecipeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch()
    }
}

extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        let recipe = recipes[indexPath.item]
        if CoreDataStack.shared.isRecipeFavorite(uri: recipe.uri) {
            if let favoriteRecipe = CoreDataStack.shared.fetchFavoriteRecipe(uri: recipe.uri) {
                cell.configure(with: favoriteRecipe)
            }
        } else {
            cell.configure(with: recipe)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRecipe = recipes[indexPath.item]
        presenter.didSelectRecipe(selectedRecipe, at: indexPath.item)
    }
    
    func createDetailViewController(with recipe: Recipe, at index: Int) -> RecipeDetailViewController {
        let detailPresenter = RecipeDetailPresenter(view: nil, recipe: recipe, recipeIndex: index)
        let detailViewController = RecipeDetailViewController(presenter: detailPresenter)
        return detailViewController
    }
    
    func navigateToDetailViewController(with recipe: Recipe, at index: Int) {
        let detailsVC = createDetailViewController(with: recipe, at: index)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension RecipeViewController: RecipeViewProtocol {
    func displayRecipes(_ recipes: [Recipe]) {
        DispatchQueue.main.async {
            self.recipes = recipes
            self.recipeView.collectionView.reloadData()
        }
    }
    
    func displayError(_ error: Error) {
        // Handle error
    }
}

extension RecipeViewController: FilterViewProtocol {
    func showFilters(diet: [String], health: [String], cuisineType: [String], dishType: [String]) {
        
    }
    
    func applyFilters(diet: String?, health: String?, cuisineType: String?,  dishType: String?) {
        selectedDiet = diet
        selectedHealth = health
        selectedCuisine = cuisineType
        selectedDishType = dishType
        
        performSearch()
    }
}
