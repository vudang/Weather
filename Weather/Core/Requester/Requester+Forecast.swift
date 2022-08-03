//
//  Requester+Forecast.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import RxSwift

extension Requester {
    static func fetchListForecast(for city: String,
                                  apiKey: String,
                                  noOfDays: Int,
                                  unit: String) -> Observable<(WeatherEntity?, AppError?)> {
        let router = APIRouter.fetchForecast(cityName: city, apiKey: apiKey, noOfDays: noOfDays, unit: unit)
        let request: Observable<(HTTPURLResponse, WeatherEntity?)> = Requester.requestDTO(using: router)
        return request.flatMap { (res) -> Observable<(WeatherEntity?, AppError?)> in
            let error = AppError.toAppError(from: res.1?.cod)
            return Observable.just((res.1, error))
        }
    }
}
