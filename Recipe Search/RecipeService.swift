import Moya
import Foundation

enum RecipeAPI {
    case searchRecipes(query: String)
}

extension RecipeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.edamam.com/api/recipes/v2")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .searchRecipes(let query):
            return .requestParameters(parameters: [
                "type": "public",
                "beta": "true",
                "q": query,
                "app_id": "fc2be799",
                "app_key": "93cd0304b865baba271a523865945913",
                "diet": "balanced",
                "health": "alcohol-free",
                "cuisineType": "Italian",
                "mealType": "Breakfast",
                "dishType": "Main course",
                "calories": "100-300",
                "time": "1",
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
    func fetchRecipes(query: String, completion: @escaping (Result<[Recipe], Error>) -> Void)
}

class RecipeService: RecipeServiceProtocol {
    private let provider = MoyaProvider<RecipeAPI>()
    
    func fetchRecipes(query: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        provider.request(.searchRecipes(query: query)) { result in
            switch result {
            case .success(let response):
                do {
                    //print("Response Data: \(String(data: response.data, encoding: .utf8) ?? "No data")")  // Отладочный вывод
                    let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: response.data)
                    let recipes = recipeResponse.hits.map { $0.recipe }
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


