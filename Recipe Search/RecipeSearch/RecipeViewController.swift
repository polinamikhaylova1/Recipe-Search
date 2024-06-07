import UIKit

class RecipeViewController: UIViewController {
    private var recipes: [Recipe] = []
    private let presenter: RecipePresenterProtocol
    //private let searchBar = UISearchBar()
    //private let collectionView: UICollectionView
    
    init(presenter: RecipePresenterProtocol) {
        self.presenter = presenter
        //let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 150, height: 200)
        //self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    private let mealTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Breakfast", "Lunch", "Dinner", "Snack"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter.setView(view: self)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCell")
        mealTypeSegmentedControl.addTarget(self, action: #selector(mealTypeChanged(_:)), for: .valueChanged)
        
        view.addSubview(mealTypeSegmentedControl)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    @objc private func mealTypeChanged(_ sender: UISegmentedControl) {
        let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
        let selectedMealType = mealTypes[sender.selectedSegmentIndex]
        presenter.searchRecipes(query: "", mealType: selectedMealType)

    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        mealTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealTypeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mealTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
            searchBar.topAnchor.constraint(equalTo: mealTypeSegmentedControl.bottomAnchor),
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
        guard let query = searchBar.text, !query.isEmpty else { return }
        let selectedMealTypeIndex = mealTypeSegmentedControl.selectedSegmentIndex
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
        presenter.didSelectRecipe(selectedRecipe)
    }
    private func createDetailViewController(with recipe: Recipe) -> RecipeDetailViewController {
        let detailPresenter = RecipeDetailPresenter(view: nil, recipe: recipe)
        let detailViewController = RecipeDetailViewController(presenter: detailPresenter)
        return detailViewController
    }
            
    func navigateToDetailViewController(with recipe: Recipe) {
        let detailsVC = createDetailViewController(with: recipe)
        navigationController?.pushViewController(detailsVC, animated: true)
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
    }
}

