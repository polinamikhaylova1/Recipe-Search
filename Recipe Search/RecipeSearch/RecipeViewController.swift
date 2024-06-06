import UIKit

class RecipeViewController: UIViewController {
    private var recipes: [Recipe] = []
    private let presenter: RecipePresenterProtocol
    private let searchBar = UISearchBar()
    private let collectionView: UICollectionView
    
    init(presenter: RecipePresenterProtocol) {
        self.presenter = presenter
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 150)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter.loadRecipesFromCoreData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCell")
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RecipeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchRecipes(query: searchText)
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
        let detailViewController = createDetailViewController(for: selectedRecipe)
        navigateToDetailViewController(detailViewController)
    }        
    private func createDetailViewController(for recipe: Recipe) -> RecipeDetailViewController {
        
        let detailPresenter = RecipeDetailPresenter(view: nil, recipe: recipe)
        let detailViewController = RecipeDetailViewController(presenter: detailPresenter)
        return detailViewController
    }
            
    private func navigateToDetailViewController(_ viewController: RecipeDetailViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RecipeViewController: RecipeViewProtocol {
    func displayRecipes(_ recipes: [Recipe]) {
        DispatchQueue.main.async {
            self.recipes = recipes
            self.collectionView.reloadData()
        }
    }
    
    func displayError(_ error: Error) {
        // Handle error (e.g., show an alert)
    }
}

