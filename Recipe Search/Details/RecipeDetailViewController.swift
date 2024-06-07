import UIKit

final class RecipeDetailViewController: UIViewController, RecipeDetailViewProtocol {
    
    private var presenter: RecipeDetailPresenterProtocol
    
    private var recipeDetailView = RecipeDetailView()
    
    init(presenter: RecipeDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        recipeDetailView = RecipeDetailView()
        self.view = recipeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeDetailView.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        presenter.didLoad(view: self)
    }
    
    @objc private func favoriteButtonTapped() {
        presenter.buttonTapped()
    }
    
    func displaySuccessMessage(_ message: String) {
        let alert = UIAlertController(title: "Успех", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func displayErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func setTitle(_ title: String) {
        recipeDetailView.titleLabel.text = title
    }
    
    func setImage(url: URL) {
        //recipeDetailView.imageView.load(url: url)
    }
    
    func setNutrients(_ nutrients: String) {
       // recipeDetailView.nutrientsLabel.text = nutrients
    }
    
    func setIngredients(_ ingredients: String) {
        //еrecipeDetailView.ingredientsLabel.text = ingredients
    }
}

