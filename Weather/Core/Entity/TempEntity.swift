//
//  TempEntity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct TempEntity: Codable {
    let day, min, max, night: Double?
    let eve, morn: Double?
}

extension TempEntity: Entity {
    func toModel() -> Temperature {
        return Temperature(day: day,
                           min: min,
                           max: max,
                           night: night,
                           evening: eve,
                           morning: morn)
    }
}
