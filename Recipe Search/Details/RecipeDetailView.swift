import UIKit


class RecipeDetailView: UIView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    //let nutrientsLabel = UILabel()
    let ingredientsLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        //nutrientsLabel.font = .systemFont(ofSize: 16)
        //nutrientsLabel.numberOfLines = 0
        
        ingredientsLabel.font = .systemFont(ofSize: 14)
        ingredientsLabel.numberOfLines = 0
        
        favoriteButton.setTitle("Добавить в избранное", for: .normal)
        
        addSubview(imageView)
        addSubview(titleLabel)
        //addSubview(nutrientsLabel)
        addSubview(ingredientsLabel)
        addSubview(favoriteButton)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
       // nutrientsLabel.translatesAutoresizingMaskIntoConstraints = false
        //ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
        
     //       nutrientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
       //     nutrientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
         //   nutrientsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        
            ingredientsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ingredientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            favoriteButton.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
            favoriteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 16)
        ])
    }
}

