//
//  FeelsLikeStoreable.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RealmSwift

class FeelLikeStoreable: Object {
    @objc dynamic var day: Double = 0.0
    @objc dynamic var night: Double = 0.0
    @objc dynamic var eve: Double = 0.0
    @objc dynamic var morn: Double = 0.0
}

extension FeelLikeStoreable: Storable {
    func toModel() -> FeelsLike {
        return FeelsLike(day: day,
                         night: night,
                         evening: eve,
                         morning: morn)
    }
}
