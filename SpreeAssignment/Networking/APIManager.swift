//
//  APIManager.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import Foundation

enum APICall {
    
    case getUserProfile(String)
    case getFollowers(String)
    case getFollowings(String)
    
    private enum BaseURL {
        case dev
        case prod
        
        var getBaseUrl: String {
            switch self {
            case .dev:
                "https://api.github.com"
            case .prod:
                "https://api.github.com"
            }
        }
    }
    
    private enum HTTPMethod: String {
        case get = "GET"
    }
    
    private var getBaseUrl: String {
        switch self {
        case .getUserProfile(_):
            return BaseURL.prod.getBaseUrl
        case .getFollowers:
            return BaseURL.prod.getBaseUrl
        case .getFollowings:
            return BaseURL.prod.getBaseUrl
        }
    }
    
    private var path: String {
        switch self {
        case .getUserProfile(let str):
            return "/users/\(str)"
        case .getFollowers(let str):
            return "/users/\(str)/followers"
        case .getFollowings(let str):
            return "/users/\(str)/following"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getUserProfile(_):
            return .get
        case .getFollowers(_):
            return .get
        case .getFollowings(_):
            return .get
        }
    }
    
    fileprivate func asURLRequest() -> URLRequest? {
        var urlString = getBaseUrl + path
        
        guard let url = URL(string: urlString) else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}

final class APIManager {
    static let shared = APIManager()
    private init(){}
    
    func makeAPICall<T: Decodable>(call: APICall, completion: @escaping (Result<T, NetworkError>) -> Void){
        guard let request = call.asURLRequest() else {
            completion(.failure(.invalidRequest))
            return
        }
        
        let session = URLSession.shared.dataTask(with: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    }catch {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
            
        }
        
        session.resume()
    }
}
