import Moya
import Foundation

enum RecipeAPI {
    case searchRecipes(query: String, mealType: String)
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
        case .searchRecipes(let query, let mealType):
            return .requestParameters(parameters: [
                "type": "public",
                "beta": true,
                "q": query,
                "app_id": "fc2be799",
                "app_key": "93cd0304b865baba271a523865945913",
                "diet": "balanced",
                "health": "alcohol-free",
                "cuisineType": "American",
                "mealType": mealType,
                "dishType": "Main course",
                "calories": "0-10000",
                "time": "300",
                "imageSize": "SMALL"
            ], encoding: URLEncoding.queryString)
            }
        }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}

protocol RecipeServiceProtocol {
    func fetchRecipes(query: String, mealType: String, completion: @escaping (Result<[Recipe], Error>) -> Void)
}

class RecipeService: RecipeServiceProtocol {
    private let provider = MoyaProvider<RecipeAPI>()
    
    func fetchRecipes(query: String,mealType: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        provider.request(.searchRecipes(query: query, mealType: mealType)) { result in
            switch result {
            case .success(let response):
                do {
                    let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: response.data)
                    let recipes = recipesResponse.hits.map { $0.recipe }
                completion(.success(recipes))
                } catch {
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


