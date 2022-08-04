//
//  WeatherStoreable.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherStoreable: Object {
    @objc dynamic var id: String?
    @objc dynamic var city: CityStoreable?
    @objc dynamic var noOfDays: Int = 0
    @objc dynamic var statusCode: String?
    var forecasts = List<ForecastStoreable>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension WeatherStoreable: Storable {
    func toModel() -> Weather {
        return Weather(city: city?.toModel(),
                       statusCode: statusCode,
                       noOfDays: noOfDays,
                       forecasts: forecasts.map { $0.toModel() })
    }
}
