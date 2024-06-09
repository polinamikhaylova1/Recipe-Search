import UIKit

final class RecipeView: UIView {
    let mealTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Breakfast", "Brunch", "Dinner", "Snack"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .systemGray6
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
        
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let image = UIImage(systemName: "line.horizontal.3.decrease.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
       
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}
private extension RecipeView {
    func setupView() {
        //backgroundColor = .white
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCell")
        addSubview(mealTypeSegmentedControl)
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(filterButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mealTypeSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mealTypeSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealTypeSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: mealTypeSegmentedControl.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            filterButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

