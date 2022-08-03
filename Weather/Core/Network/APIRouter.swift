//
//  APIRouter.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

public enum APIRouter: APIRequestProtocol {
    case fetchForecast(cityName: String, apiKey: String, noOfDays: Int, unit: String)
}


// MARK: - Path define
extension APIRouter {
    public var path: String {
        switch self {
        case .fetchForecast(_, _, _, _):
            return "\(API.domain)/data/2.5/forecast/daily"
        }
    }
}


// MARK: - Params
extension APIRouter {
    public var params: [String : Any]? {
        switch self {
        case let .fetchForecast(cityName, apiKey, noOfDays, unit):
            return [
                "q": cityName,
                "appid": apiKey,
                "cnt": noOfDays,
                "units": unit
            ]
        }
    }
}

// MARK: - Header
var defaultHeader: [String: String] = [:]
extension APIRouter {
    public var header: [String : String]? {
        switch self {
        default:
            return defaultHeader
        }
    }
}
