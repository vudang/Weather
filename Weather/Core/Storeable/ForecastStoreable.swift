//
//  ForecastStoreable.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RealmSwift

class ForecastStoreable: Object {
    @objc dynamic var dayTime: Int = 0
    @objc dynamic var temperature: TempStoreable?
    @objc dynamic var feelsLike: FeelLikeStoreable?
    @objc dynamic var pressure: Int = 0
    @objc dynamic var humidity: Int = 0
    var weathers = List<WeatherInfoStoreable>()
    
}

extension ForecastStoreable: Storable {
    func toModel() -> Forecast {
        return Forecast(dayTime: dayTime,
                        temperature: temperature?.toModel(),
                        feelsLike: feelsLike?.toModel(),
                        pressure: pressure,
                        humidity: humidity,
                        weather: weathers.map { $0.toModel() })
    }
}
