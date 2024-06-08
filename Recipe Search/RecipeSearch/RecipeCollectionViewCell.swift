import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell {
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalTime: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 7
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
            totalTime.text = "Total time: \(String(recipe.totalTime)) min"
        } else {
            totalTime.text = nil
        }
        loadImage(from: recipe.image)
        let ingredientTexts = recipe.ingredients.map { $0.text }
        ingredientsLabel.text = "Ingredients:\n\(ingredientTexts.joined(separator: ",\n"))"
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
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(totalTime)
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
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        
            ingredientsLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 1),
            ingredientsLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            ingredientsLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            
            totalTime.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 1),
            totalTime.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            totalTime.trailingAnchor.constraint(equalTo: label.trailingAnchor),
        ])
    }
}
