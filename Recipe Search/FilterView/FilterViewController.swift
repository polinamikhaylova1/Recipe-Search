import UIKit
import SafariServices

protocol FilterViewProtocol: AnyObject {
    func applyFilters(diet: String?, health: String?, cuisineType: String?,  dishType: String?)
}

final class FilterViewController: UIViewController {
    private var presenter: FilterPresenterProtocol?
    weak var delegate: FilterViewProtocol?
    private let filterView = FilterView()

    override func loadView() {
        self.view = filterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        filterView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    @objc func doneButtonTapped() {
        delegate?.applyFilters(diet: filterView.selectedDiet, health: filterView.selectedHealth, cuisineType: filterView.selectedCuisine, dishType: filterView.selectedDishType)
        dismiss(animated: true, completion: nil)
    }

    func setPresenter(_ presenter: FilterPresenterProtocol) {
        self.presenter = presenter
    }
}

