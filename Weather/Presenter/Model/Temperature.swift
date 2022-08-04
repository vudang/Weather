//
//  Temperature.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct Temperature: Modelable {
    let day, min, max: Double?
    let night, evening, morning: Double?
}

extension Temperature {
    var averageValue: String {
        let avg = Int((min.unwrapValue() + max.unwrapValue()) / 2)
        return "\(avg)°C"
    }
    
    func toStorable() -> TempStoreable {
        let temp = TempStoreable()
        temp.day = day.unwrapValue()
        temp.min = min.unwrapValue()
        temp.max = max.unwrapValue()
        temp.night = night.unwrapValue()
        temp.eve = evening.unwrapValue()
        temp.morn = morning.unwrapValue()
        return temp
    }
}
