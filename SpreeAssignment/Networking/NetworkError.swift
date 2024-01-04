//
//  NetworkError.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
    
    init?(data: Data?, response: URLResponse?, error: Error?) {
            if let error = error {
                self = .transportError(error)
                return
            }

            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                self = .serverError(statusCode: response.statusCode)
                return
            }
            
            if data == nil {
                self = .noData
            }
            
            return nil
        }
}

extension NetworkError{
    var getErrorString: String {
        switch self {
        case .invalidRequest:
            "Invalid Request"
        case .transportError(_):
            "Check your Internet Connection"
        case .serverError(_):
            "Server side Error"
        case .noData:
            "No data available"
        case .decodingError(_):
            "Invalid response"
        }
    }
}
