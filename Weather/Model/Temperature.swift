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
}
