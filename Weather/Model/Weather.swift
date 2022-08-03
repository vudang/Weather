//
//  Weather.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct Weather: Modelable {
    let city: City?
    let statusCode: String?
    let noOfDays: Int?
    let forecasts: [Forecast]?
}
