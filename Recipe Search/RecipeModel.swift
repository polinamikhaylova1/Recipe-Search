
import Foundation

struct RecipeModel {
    let label: String
    let image: String
    let ingredients: String
    let totalTime: Double
    let uri: String
    let calories: Double
    //let totalNutrients: [String: TotalNutrientDTO2]
    // let calories: Double
}

struct TotalNutrientDTO2 {
    let label: String
    let quantity: Double
    let unit: String
}

struct Ingredients {
    let text: String
//    let weight: Double?
}
