//
//  AppError.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

enum StatusCode: Int {
    case success = 200
    case notFound = 404
    case invalidRequest = 400
    case internalServer = 500
}

enum AppError: Error {
    case dataNotFound
    case invalidRequest
    case serverError
    case unknown
    
    var message: String {
        switch self {
        case .dataNotFound:
            return "The requested data could not be found"
        case .invalidRequest:
            return "Invalid search request"
        case .serverError:
            return "There is a problem with the system"
        case .unknown:
            return "An error occurred, please try again later"
        }
    }
}

extension AppError {
    static func toAppError(from code: String?) -> AppError? {
        guard let code = Int(code ?? ""),
              let statusCode = StatusCode(rawValue: code) else {
            return AppError.unknown
        }
        
        switch statusCode {
        case .notFound:
            return AppError.dataNotFound
        case .invalidRequest:
            return AppError.invalidRequest
        case .internalServer:
            return AppError.invalidRequest
        case .success:
            return nil
        }
    }
}
