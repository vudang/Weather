//
//  TempStoreable.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RealmSwift

class TempStoreable: Object {
    @objc dynamic var day: Double = 0
    @objc dynamic var min: Double = 0
    @objc dynamic var max: Double = 0
    @objc dynamic var night: Double = 0
    @objc dynamic var eve: Double = 0
    @objc dynamic var morn: Double = 0
}

extension TempStoreable: Storable {
    func toModel() -> Temperature {
        return Temperature(day: day,
                           min: min,
                           max: max,
                           night: night,
                           evening: eve,
                           morning: morn)
    }
}
