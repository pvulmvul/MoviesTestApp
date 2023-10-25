//
//  API.swift
//  MoviesTestApp
//
//  Created by Paul Maul on 24.10.2023.
//

import Foundation
import Alamofire

class API<T: TargetType> {
    
    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completionHandler:@escaping (Result<M, NetworkError>)-> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)
        
        AF.request(target.baseURL + target.path, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {
                completionHandler(.failure(.unknown))
                return
            }
            
            if statusCode == 200 {
                guard let jsonResponse = try? response.result.get() else {
                    completionHandler(.failure(.unknown))
                    return
                }
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    completionHandler(.failure(.unknown))
                    return
                }
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    completionHandler(.failure(.unknown))
                    return
                }
                completionHandler(.success(responseObj))
                
            } else {
                switch statusCode {
                case 401:
                    completionHandler(.failure(.unauthorized))
                case 404:
                    completionHandler(.failure(.notFound))
                case 400:
                    completionHandler(.failure(.badRequest))
                case 403:
                    completionHandler(.failure(.forbidden))
                case 500:
                    completionHandler(.failure(.serverError))
                default:
                    completionHandler(.failure(.unknown))
                }
            }
        }
    }
    
    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding){
        switch task {
        case .request:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
    
    
}
