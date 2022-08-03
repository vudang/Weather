//
//  ForecastEntity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct ForecastEntity: Codable {
    let dt, sunrise, sunset: Int?
    let temp: TempEntity?
    let feelsLike: FeelsLikeEntity?
    let pressure, humidity: Int?
    let weather: [WeatherInfoEntity]?
    let speed: Double?
    let deg: Int?
    let gust: Double?
    let clouds: Int?
    let pop, rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, weather, speed, deg, gust, clouds, pop, rain
    }
}

extension ForecastEntity: Entity {
    func toModel() -> Forecast {
        let temp = self.temp?.toModel()
        let feelLike = self.feelsLike?.toModel()
        let weathers = self.weather?.map { $0.toModel() }
        return Forecast(dayTime: dt,
                        temperature: temp,
                        feelsLike: feelLike,
                        pressure: pressure,
                        humidity: humidity,
                        weather: weathers)
    }
}
