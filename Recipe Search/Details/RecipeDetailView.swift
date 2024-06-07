import UIKit

final class RecipeDetailView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    //let nutrientsLabel = UILabel()
    //nutrientsLabel.font = .systemFont(ofSize: 16)
    //nutrientsLabel.numberOfLines = 0
    
    let ingredientsLabel: UILabel={
        let ingredientsLabel = UILabel()
        ingredientsLabel.font = .systemFont(ofSize: 14)
        ingredientsLabel.numberOfLines = 5
        return ingredientsLabel
    }()
    let favoriteButton: UIButton = {
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setTitle("Добавить в избранное", for: .normal)
        return favoriteButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
private extension RecipeDetailView {
    func setupUI() {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(titleLabel)
        //addSubview(nutrientsLabel)
        addSubview(ingredientsLabel)
        addSubview(favoriteButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

            ingredientsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            ingredientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            favoriteButton.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            favoriteButton.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: 16)
        ])
    }
}

