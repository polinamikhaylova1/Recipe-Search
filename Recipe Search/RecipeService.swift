import Moya
import Foundation

enum RecipeAPI {
    case searchRecipes(query: String)
    case recipeById(id: String)
}

extension RecipeAPI: TargetType {
    static let API_KEY = "93cd0304b865baba271a523865945913"
    static let APP_ID = "fc2be799"
    
    var baseURL: URL {
        return URL(string: "https://api.edamam.com/api/recipes/v2")!
    }
    
    var path: String {
        switch self {
        case .searchRecipes:
            return ""
        case .recipeById(let id):
            return "/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .searchRecipes(let name):
            return .requestParameters(parameters: ["type": "public", "beta": "false", "q": name, "app_id": RecipeAPI.APP_ID, "app_key": RecipeAPI.API_KEY], encoding: URLEncoding.queryString)
        case .recipeById:
            return .requestParameters(parameters: ["type": "public", "app_id": RecipeAPI.APP_ID, "app_key": RecipeAPI.API_KEY], encoding: URLEncoding.queryString)
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
                    let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: response.data)
                    let recipes = recipeResponse.hits.map { $0.recipe }
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


