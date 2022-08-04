//
//  Weather.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct Weather: Modelable {
    let city: City?
    let statusCode: String?
    let noOfDays: Int?
    let forecasts: [Forecast]?
}

extension Weather {
    var weatherId: String {
        return "\((city?.id).unwrapValue())"
    }
    
    func toStorable() -> WeatherStoreable {
        let weather = WeatherStoreable()
        weather.id = weatherId
        weather.city = city?.toStorable()
        weather.statusCode = statusCode
        weather.noOfDays = noOfDays.unwrapValue()
        let forecasts = forecasts?.map { $0.toStorable() } ?? []
        weather.forecasts.append(objectsIn: forecasts)
        return weather
    }
}
