//
//  LocalDatabaseProtocol.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
protocol LocalDatabaseProtocol {
    func saveWeather(_ weather: Weather)
    func deleteWeather(_ weather: Weather)
    func getWeather(by cityName: String) -> Weather?
}
