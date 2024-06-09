import Moya
import Foundation

enum RecipeAPI {
    case searchRecipes(query: String, diet: String,health: String, cuisineType: String, mealType: String, dishType: String)
}

extension RecipeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.edamam.com")!
    }
    
    var path: String {
        return "/api/recipes/v2"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .searchRecipes(let query, let diet, let health,  let cuisineType, let mealType,  let dishType ):
            let parameters: [String: Any] = [
                "type": "public",
                "beta": true,
                "q": query,
                "app_id": "fc2be799",
                "app_key": "93cd0304b865baba271a523865945913",
                "diet": diet,
                "health": health,
                "cuisineType": cuisineType,
                "mealType": mealType,
                "dishType": dishType,
                "calories": "1-10000",
                "time": "300",
                "imageSize": "REGULAR" ]
                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)            }
        }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}

protocol RecipeServiceProtocol {
    func fetchRecipes(query: String, diet: String,health: String, cuisineType: String, mealType: String, dishType: String, completion: @escaping (Result<[Recipe], Error>) -> Void)
}

class RecipeService: RecipeServiceProtocol {
    private let provider = MoyaProvider<RecipeAPI>()
    
    func fetchRecipes(query: String, diet: String, health: String, cuisineType: String, mealType: String, dishType: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        provider.request(.searchRecipes(query: query, diet: diet, health: health, cuisineType: cuisineType, mealType: mealType, dishType: dishType)) { result in
            switch result {
            case .success(let response):
                do {
                    let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: response.data)
                    let recipes = recipesResponse.hits.map { $0.recipe }
                completion(.success(recipes))
                } catch {
                    print (response)
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}


