//
//  FeelsLikeEntity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct FeelsLikeEntity: Codable {
    let day, night, eve, morn: Double?
}

extension FeelsLikeEntity: Entity {
    func toModel() -> FeelsLike {
        return FeelsLike(day: self.day,
                         night: self.night,
                         evening: self.eve,
                         morning: self.morn)
    }
}
