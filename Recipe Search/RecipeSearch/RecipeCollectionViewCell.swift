import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell {
    let heartImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .red // Установите цвет сердца
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalTime: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let calories: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 7
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with recipe: Recipe) {
        label.text = recipe.label
        if recipe.totalTime != 0 {
            totalTime.text = "Total time: \(Int(recipe.totalTime.rounded())) min"
        } else {
            totalTime.text = nil
        }
        calories.text = "Calories: \(Int(recipe.calories.rounded())) kcal"
        loadImage(from: recipe.image)
        let ingredientTexts = recipe.ingredients.map { $0.text }
        ingredientsLabel.text = "Ingredients:\n\(ingredientTexts.joined(separator: ",\n"))"
        heartImageView.isHidden = true
    }
    
    func configure(with favoriteRecipe: FavoriteRecipies) {
        label.text = favoriteRecipe.label
        if favoriteRecipe.totalTime != 0 {
            totalTime.text = "Total time: \(Int(favoriteRecipe.totalTime.rounded())) min"
        } else {
            totalTime.text = nil
        }
        calories.text = "Calories: \(Int(favoriteRecipe.calories.rounded())) kcal"
        if let imageUrlString = favoriteRecipe.image,
               let imageUrl = URL(string: imageUrlString) { 
                loadImage(from: imageUrl)
            }
        let ingredientTexts = favoriteRecipe.ingredients.components(separatedBy: ", ")
        ingredientsLabel.text = "Ingredients:\n\(ingredientTexts.joined(separator:",\n")))"
        heartImageView.isHidden = false
    }
        
    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                 let _ = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.imageView.image = nil
                }
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = nil
                    }
                }
            }
            
            task.resume()
        }
    }
    
}
extension RecipeCollectionViewCell {
    func setupUI() {
        contentView.addSubview(heartImageView)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(totalTime)
        contentView.addSubview(calories)
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.orange.cgColor
        contentView.layer.cornerRadius = 10
        setupConstraint()
    }
    func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
                    
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                        
            ingredientsLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 1),
            ingredientsLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            ingredientsLabel.trailingAnchor.constraint(equalTo: heartImageView.trailingAnchor),
            
            totalTime.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 1),
            totalTime.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            totalTime.trailingAnchor.constraint(equalTo: heartImageView.trailingAnchor),
            
            calories.topAnchor.constraint(equalTo: totalTime.bottomAnchor, constant: 1),
            calories.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            calories.trailingAnchor.constraint(equalTo: heartImageView.trailingAnchor),
            
            heartImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            heartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heartImageView.widthAnchor.constraint(equalToConstant: 20),
            heartImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
