import UIKit

final class FilterView: UIView {
    let cuisines = ["American", "Italian", "Mexican", "Chinese", "Indian", "Asian", "British", "French", "Nordic"]
    let healthOptions = ["gluten-free", "vegan", "vegetarian", "pork-free", "alcohol-cocktail", "alcohol-free", "celery-free", "crustacean-free", "dairy-free", "DASH", "egg-free", "fish-free", "fodmap-free"]
    let dishTypes = ["Main course", "Side dish", "Desserts", "Drinks", "Salad", "Soup", "Starter"]
    let diets = ["balanced", "high-protein", "high-fiber", "low-carb", "low-fat", "low-sodium"]

    var selectedCuisine: String? {
        didSet {
            UserDefaults.standard.set(selectedCuisine, forKey: "selectedCuisine")
        }
    }
    var selectedHealth: String? {
        didSet {
            UserDefaults.standard.set(selectedHealth, forKey: "selectedHealth")
        }
    }
    var selectedDishType: String? {
        didSet {
            UserDefaults.standard.set(selectedDishType, forKey: "selectedDishType")
        }
    }
    var selectedDiet: String? {
        didSet {
            UserDefaults.standard.set(selectedDiet, forKey: "selectedDiet")
        }
    }
    private var selectedCuisineButton: UIButton?
        private var selectedHealthButton: UIButton?
        private var selectedDishTypeButton: UIButton?
        private var selectedDietButton: UIButton?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()

    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.systemOrange, for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        loadSelections()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        setupScrollView()
        setupStackView()
        setupFilterSection(title: "Cuisine Type", options: cuisines, selector: #selector(cuisineSelected(_:)))
        setupFilterSection(title: "Health", options: healthOptions, selector: #selector(healthSelected(_:)))
        setupFilterSection(title: "Dish Type", options: dishTypes, selector: #selector(dishTypeSelected(_:)))
        setupFilterSection(title: "Diet", options: diets, selector: #selector(dietSelected(_:)))
        setupDoneButton()
    }


    private func setupFilterSection(title: String, options: [String], selector: Selector) {
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
            
            if let selectedOption = selectedOption(for: title), selectedOption == option {
                button.backgroundColor = .systemOrange
                updateSelectedButton(for: title, button: button)}
        }

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(optionsScrollView)
    }

    private func setupDoneButton() {
        stackView.addArrangedSubview(doneButton)
    }
    
    private func selectedOption(for title: String) -> String? {
        switch title {
        case "Cuisine Type":
            return selectedCuisine
        case "Health":
            return selectedHealth
        case "Dish Type":
            return selectedDishType
        case "Diet":
            return selectedDiet
        default:
            return nil
        }
    }

    private func loadSelections() {
        selectedCuisine = UserDefaults.standard.string(forKey: "selectedCuisine")
        selectedHealth = UserDefaults.standard.string(forKey: "selectedHealth")
        selectedDishType = UserDefaults.standard.string(forKey: "selectedDishType")
        selectedDiet = UserDefaults.standard.string(forKey: "selectedDiet")
    }
    private func updateSelectedButton(for category: String, button: UIButton) {
        switch category {
        case "Cuisine Type":
            selectedCuisineButton?.backgroundColor = .clear
            selectedCuisineButton = button
        case "Health":
            selectedHealthButton?.backgroundColor = .clear
            selectedHealthButton = button
        case "Dish Type":
            selectedDishTypeButton?.backgroundColor = .clear
            selectedDishTypeButton = button
        case "Diet":
            selectedDietButton?.backgroundColor = .clear
            selectedDietButton = button
        default:
            break
        }
    }

    @objc func cuisineSelected(_ sender: UIButton) {
        selectedCuisine = sender.titleLabel?.text
        updateSelectedButton(for: "Cuisine Type", button: sender)
        sender.backgroundColor = .systemOrange
    }

    @objc func healthSelected(_ sender: UIButton) {            
        selectedHealth = sender.titleLabel?.text
        updateSelectedButton(for: "Health", button: sender)
        sender.backgroundColor = .systemOrange
    }

    @objc func dishTypeSelected(_ sender: UIButton) {
        selectedDishType = sender.titleLabel?.text
        updateSelectedButton(for: "Dish Type", button: sender)
        sender.backgroundColor = .systemOrange
    }
    
    @objc func dietSelected(_ sender: UIButton) {
        selectedDiet = sender.titleLabel?.text
        updateSelectedButton(for: "Diet", button: sender)
        sender.backgroundColor = .systemOrange
    }
}
private extension FilterView {
    func setupScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
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
}
    

