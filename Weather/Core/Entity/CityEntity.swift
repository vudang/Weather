//
//  CityEntity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct CityEntity: Codable {
    let id: Int?
    let name: String?
    let coord: CoordEntity?
    let country: String?
    let population, timezone: Int?
}

struct CoordEntity: Codable {
    let lon, lat: Double?
}

extension CityEntity: Entity {
    func toModel() -> City {
        return City(id: self.id,
                    name: self.name,
                    country: self.country,
                    timezone: self.timezone)
    }
}
