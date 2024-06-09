import UIKit

final class TabBarController: UITabBarController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
    }
    
    // MARK: - Private Properties
    private let firstViewController: UIViewController
    private let secondViewController: UIViewController
    
    
    // MARK: - Initialization
    init(
        
        firstViewController: UIViewController = RecipeViewController(presenter: RecipePresenter(view: nil)),
        secondViewController: UIViewController = FavoritesViewController()
    ) {
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupTabBarController() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
        
        tabBar.tintColor = .label
        
        
                
        let firstTab = createNav(for: firstViewController, title: "Search", image: UIImage(systemName: "magnifyingglass"))
        let secondTab = createNav(for: secondViewController, title: "Favorites", image: UIImage(systemName: "star.fill"))
        
        
        
        setViewControllers([firstTab, secondTab], animated: true)
    }
    
    private func createNav(for rootViewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            navController.navigationBar.prefersLargeTitles = false
            rootViewController.navigationItem.title = title
            return navController
        }
}

