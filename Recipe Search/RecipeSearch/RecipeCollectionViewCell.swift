import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = UIFont.boldSystemFont(ofSize: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(ingredientsLabel)
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        imageView.widthAnchor.constraint(equalToConstant: 150),
                        imageView.heightAnchor.constraint(equalToConstant: 150),
                            
                        label.topAnchor.constraint(equalTo: contentView.topAnchor),
                        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        
                        ingredientsLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 1),
                        ingredientsLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                        ingredientsLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                        //ingredientsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with recipe: Recipe) {
        label.text = recipe.label
        loadImage(from: recipe.image)
        let ingredientTexts = recipe.ingredients.map { $0.text }
        ingredientsLabel.text = "Ingredients: \(ingredientTexts.joined(separator: ", "))"
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
