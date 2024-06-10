protocol FilterPresenterProtocol: AnyObject {
    func applyFilters(diet: String?, health: String?, cuisineType: String?,  dishType: String?)
}

class FilterPresenter: FilterPresenterProtocol {
    weak var view: FilterViewProtocol?
    
    init(view: FilterViewProtocol) {
        self.view = view
    }
    
    func applyFilters(diet: String?, health: String?, cuisineType: String?,  dishType: String?) {
        view?.applyFilters(diet: diet, health: health, cuisineType: cuisineType,  dishType: dishType)
    }
    
    
    
    
}
