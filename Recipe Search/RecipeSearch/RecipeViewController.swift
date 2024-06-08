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
    
    init(presenter: RecipePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeView.searchBar.delegate = self
        recipeView.collectionView.delegate = self
        recipeView.collectionView.dataSource = self
        recipeView.mealTypeSegmentedControl.addTarget(self, action: #selector(mealTypeChanged(_:)), for: .valueChanged)
        presenter.setView(view: self)
        title = "Search"
    }
    override func loadView() {
        recipeView = RecipeView()
        self.view = recipeView
    }
    
    @objc private func mealTypeChanged(_ sender: UISegmentedControl) {
        let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
        let selectedMealType = mealTypes[sender.selectedSegmentIndex]
        presenter.searchRecipes(query: "", mealType: selectedMealType)

    }
    
}

extension RecipeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        let selectedMealTypeIndex = recipeView.mealTypeSegmentedControl.selectedSegmentIndex
        let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
        let selectedMealType = mealTypes[selectedMealTypeIndex]
        presenter.searchRecipes(query: query, mealType: selectedMealType)
    }
}

extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        let recipe = recipes[indexPath.item]
        cell.configure(with: recipe)
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
    }
}

