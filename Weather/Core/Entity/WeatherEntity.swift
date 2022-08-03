//
//  Currency.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct WeatherEntity: Codable {
    let city: CityEntity?
    let cod: String?
    let cnt: Int?
    let list: [ForecastEntity]?
}

extension WeatherEntity: Entity {
    func toModel() -> Weather {
        return Weather(city: self.city?.toModel(),
                       statusCode: cod,
                       noOfDays: self.cnt,
                       forecasts: self.list?.map { $0.toModel() })
    }
}
