import UIKit

protocol RecipeDetailViewProtocol: AnyObject {
    func displaySuccessMessage(_ message: String)
    func displayErrorMessage(_ message: String)
    func setTitle(_ title: String)
    func setImage(url: URL)
    func setTotalNutrients(_ totalNutrients: [String])
    func setIngredients(_ ingredients: [Ingredient])
    func updateContentSize() 
}

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
    
    
}
extension RecipeDetailViewController {
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
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.recipeDetailView.imageView.image = image
                }
            }
        }
    }
    
    func setTotalNutrients(_ totalNutrients: [String]) {
        recipeDetailView.nutrientsLabel.text = "Nutrients:\n" + totalNutrients.joined(separator:",\n")
    }
    
    func setIngredients(_ ingredients: [Ingredient]) {
        let ingredientTexts = ingredients.map { $0.text }
        recipeDetailView.ingredientsLabel.text = "Ingredients:\n\(ingredientTexts.joined(separator:",\n"))"
    }
    func updateContentSize() {
        recipeDetailView.scrollView.contentSize = recipeDetailView.contentView.bounds.size
    }
}

