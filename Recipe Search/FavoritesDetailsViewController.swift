import UIKit
import SafariServices

protocol FavoritesDetailsViewProtocol: AnyObject {
    func displaySuccessMessage(_ message: String)
    func displayErrorMessage(_ message: String)
    func setTitle(_ title: String)
    func setImage(urlString: String)
    func setIngredients(_ ingredients: String)
    func updateContentSize()
    func openLink(url: URL)
}

final class FavoritesDetailsViewController: UIViewController, FavoritesDetailsViewProtocol {
    
    private var presenter: FavoritesDetailsPresenterProtocol
    private var favoritesDetailView = FavoritesDetailsView()
    
    init(presenter: FavoritesDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        favoritesDetailView = FavoritesDetailsView()
        self.view = favoritesDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        favoritesDetailView.favoriteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        favoritesDetailView.linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)

        presenter.didLoad(view: self)
    }
    
    @objc private func deleteButtonTapped() {
        presenter.buttonTapped()
        showAlert()
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func linkButtonTapped() {
        presenter.linkButtonTapped()
    }
    func openLink(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        
    }
    func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.orange, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButtonItem
        
    }
    func showAlert() {
        let alertController = UIAlertController(title: nil, message: "Recipe removed from favorites", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
extension FavoritesDetailsViewController {
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
        favoritesDetailView.titleLabel.text = title
    }
    
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else {
                return
            }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.favoritesDetailView.imageView.image = image
                }
            }
        }
    }
    
    
    func setIngredients(_ ingredients: String) {
        let ingredientTexts = ingredients.components(separatedBy: ", ")
        favoritesDetailView.ingredientsLabel.text = "Ingredients:\n\(ingredientTexts.joined(separator:",\n"))"
    }
    func updateContentSize() {
        favoritesDetailView.scrollView.contentSize = favoritesDetailView.contentView.bounds.size
    }
}
