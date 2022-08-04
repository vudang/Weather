//
//  WeatherInfoStoreable.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherInfoStoreable: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var main: String?
    @objc dynamic var weatherDescription: String?
    @objc dynamic var icon: String?
}

extension WeatherInfoStoreable: Storable {
    func toModel() -> WeatherInfo {
        return WeatherInfo(id: id,
                           main: main,
                           weatherDescription: weatherDescription,
                           icon: icon)
    }
}
