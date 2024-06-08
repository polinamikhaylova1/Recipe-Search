import UIKit

protocol FavoritesView: AnyObject {
    func showRecipes(_ recipes: [RecipeModel])
    func showError(_ error: String)
    func navigateToDetailViewController(with recipe: RecipeModel, at index: Int)
}

class FavoritesViewController: UIViewController, FavoritesView {
    private var recipes: [RecipeModel] = []
    var presenter: FavoritesPresenter!
    private let refreshControl = UIRefreshControl()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        presenter = FavoritesPresenter(view: self)
        presenter.viewDidLoad()
        title = "Favorites"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    func showRecipes(_ recipes: [RecipeModel]) {
        self.recipes = recipes
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    @objc private func refreshFavorites() {
        presenter.viewDidLoad()
    }
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        refreshControl.endRefreshing()
    }
    
}
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedRecipe = recipes[indexPath.row]
        presenter.didSelectRecipe(selectedRecipe, at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = recipes[indexPath.row]
            presenter.deleteRecipe(recipe)
        }
    }
    func navigateToDetailViewController(with recipe: RecipeModel, at index: Int) {
        let detailsVC = createDetailViewController(with: recipe, at: index)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    func createDetailViewController(with recipe: RecipeModel, at index: Int) -> FavoritesDetailsViewController {
        let detailPresenter = FavoritesDetailsPresenter(view: nil, recipe: recipe)
        let detailViewController = FavoritesDetailsViewController(presenter: detailPresenter)
        return detailViewController
    }
}
