//
//  Forecast.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct Forecast: Modelable {
    let dayTime: Int?
    let temperature: Temperature?
    let feelsLike: FeelsLike?
    let pressure, humidity: Int?
    let weather: [WeatherInfo]?
}

extension Forecast {
    var pressureValue: String {
        return "\(pressure.unwrapValue())"
    }
    
    var humidityValue: String {
        return "\(humidity.unwrapValue())%"
    }
    
    func toStorable() -> ForecastStoreable {
        let forecast = ForecastStoreable()
        forecast.dayTime = dayTime.unwrapValue()
        forecast.temperature = temperature?.toStorable()
        forecast.feelsLike = feelsLike?.toStorable()
        forecast.pressure = pressure.unwrapValue()
        forecast.humidity = humidity.unwrapValue()
        let weathers = weather?.map { $0.toStorable() } ?? []
        forecast.weathers.append(objectsIn: weathers)
        return forecast
    }
}
