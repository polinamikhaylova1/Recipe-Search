import UIKit
import SafariServices

protocol RecipeDetailViewProtocol: AnyObject {
    func displaySuccessMessage(_ message: String)
    func displayErrorMessage(_ message: String)
    func setTitle(_ title: String)
    func setImage(image: String)
    func setTotalNutrients(_ totalNutrients: [String])
    func setIngredients(_ ingredients: [Ingredient])
    func updateContentSize() 
    func openLink(url: URL)
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
        setupBackButton()
        recipeDetailView.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        recipeDetailView.linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)

        presenter.didLoad(view: self)
        
    }
    
    @objc private func favoriteButtonTapped() {
        presenter.buttonTapped()
        showAlert()
    }
    
    @objc private func linkButtonTapped() {
        presenter.linkButtonTapped()
    }
    func openLink(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        
    }
    func showAlert() {
        let alertController = UIAlertController(title: nil, message: "Recipe added to favorites", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.orange, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButtonItem
        
    }
}
extension RecipeDetailViewController {
    func displaySuccessMessage(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func displayErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func setTitle(_ title: String) {
        recipeDetailView.titleLabel.text = title
    }
    
    func setImage(image: String) {
        guard let url = URL(string: image) else {
                print("Invalid URL string")
                return
            }
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

