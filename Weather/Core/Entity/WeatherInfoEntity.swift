//
//  WeatherInfoEntity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct WeatherInfoEntity: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

extension WeatherInfoEntity: Entity {
    func toModel() -> WeatherInfo {
        return WeatherInfo(id: id,
                           main: main,
                           weatherDescription: weatherDescription,
                           icon: icon)
    }
}

