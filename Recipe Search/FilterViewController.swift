import UIKit

protocol FilterViewProtocol: AnyObject {
    func applyFilters(diet: String?, health: String?, cuisineType: String?,  dishType: String?)
}

final class FilterViewController: UIViewController {
    weak var delegate: FilterViewProtocol?
    private var presenter: FilterPresenterProtocol?

    private let cuisines = ["American", "Italian", "Mexican", "Chinese", "Indian","Asian","British", "French", "Nordic"]
    private let healthOptions = ["gluten-free","vegan", "vegetarian","pork-free","alcohol-cocktail", "alcohol-free", "celery-free", "crustacean-free", "dairy-free", "DASH", "egg-free", "fish-free", "fodmap-free"]
    private let dishTypes = ["Main course", "Side dish", "Desserts","Drinks", "Salad", "Soup", "Starter"]
    private let diets = ["balanced", "high-protein", "high-fiber", "low-carb","low-fat", "low-sodium"]

    private var selectedCuisine: String?
    private var selectedHealth: String?
    private var selectedDishType: String?
    private var selectedDiet: String?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    private func setupDoneButton() {
        stackView.addArrangedSubview(doneButton)
    }
    
    @objc func doneButtonTapped() {
        delegate?.applyFilters(diet: selectedDiet, health: selectedHealth, cuisineType: selectedCuisine,  dishType: selectedDishType)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cuisineSelected(_ sender: UIButton) {
        selectedCuisine = sender.titleLabel?.text
        sender.backgroundColor = .systemOrange
        
    }
    
    @objc func healthSelected(_ sender: UIButton) {
        selectedHealth = sender.titleLabel?.text
        sender.backgroundColor = .systemOrange
    }
    
    @objc func dishTypeSelected(_ sender: UIButton) {
        selectedDishType = sender.titleLabel?.text
        sender.backgroundColor = .systemOrange
    }
    
    @objc func dietSelected(_ sender: UIButton) {
        selectedDiet = sender.titleLabel?.text
        sender.backgroundColor = .systemOrange
    }
    
    func setPresenter(_ presenter: FilterPresenterProtocol) {
        self.presenter = presenter
    }
}
private extension FilterViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupStackView()
        setupFilterSection(title: "Cuisine Type", options: cuisines, selector: #selector(cuisineSelected(_:)))
        setupFilterSection(title: "Health", options: healthOptions, selector: #selector(healthSelected(_:)))
        setupFilterSection(title: "Dish Type", options: dishTypes, selector: #selector(dishTypeSelected(_:)))
        setupFilterSection(title: "Diet", options: diets, selector: #selector(dietSelected(_:)))
        setupDoneButton()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupStackView() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func setupFilterSection(title: String, options: [String], selector: Selector) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        let optionsScrollView = UIScrollView()
        optionsScrollView.showsHorizontalScrollIndicator = false
        optionsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let optionsStackView = UIStackView()
        optionsStackView.axis = .horizontal
        optionsStackView.spacing = 8
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        optionsScrollView.addSubview(optionsStackView)
        NSLayoutConstraint.activate([
            optionsStackView.topAnchor.constraint(equalTo: optionsScrollView.topAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: optionsScrollView.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: optionsScrollView.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: optionsScrollView.bottomAnchor),
            optionsStackView.heightAnchor.constraint(equalTo: optionsScrollView.heightAnchor)
        ])
        
        for option in options {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.addTarget(self, action: selector, for: .touchUpInside)
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.setTitleColor(.label, for: .normal)
            button.widthAnchor.constraint(equalToConstant: 120).isActive = true
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            optionsStackView.addArrangedSubview(button)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(optionsScrollView)
    }
}
