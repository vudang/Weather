//
//  FeelsLike.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct FeelsLike: Modelable {
    let day: Double?
    let night: Double?
    let evening: Double?
    let morning: Double?
}

extension FeelsLike {
    func toStorable() -> FeelLikeStoreable {
        let feelLike = FeelLikeStoreable()
        feelLike.day = day.unwrapValue()
        feelLike.night = night.unwrapValue()
        feelLike.eve = evening.unwrapValue()
        feelLike.morn = morning.unwrapValue()
        return feelLike
    }
}
