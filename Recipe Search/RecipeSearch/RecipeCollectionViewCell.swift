import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let nutrientsLabel = UILabel()
    private let ingredientsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        
        nutrientsLabel.font = .systemFont(ofSize: 14)
        nutrientsLabel.numberOfLines = 0
        
        ingredientsLabel.font = .systemFont(ofSize: 12)
        ingredientsLabel.numberOfLines = 0
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nutrientsLabel)
        contentView.addSubview(ingredientsLabel)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nutrientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            nutrientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            nutrientsLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            nutrientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            ingredientsLabel.topAnchor.constraint(equalTo: nutrientsLabel.bottomAnchor, constant: 8),
            ingredientsLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            ingredientsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with recipe: Recipe) {
        imageView.load(url: recipe.image)
        titleLabel.text = recipe.label
        nutrientsLabel.text = "Б: \(recipe.totalNutrients.protein.quantity) г, Ж: \(recipe.totalNutrients.fat.quantity) г, У: \(recipe.totalNutrients.carbs.quantity) г"
        ingredientsLabel.text = "Ингредиенты: " + recipe.ingredients.joined(separator: ", ")
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
