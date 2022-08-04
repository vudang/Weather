//
//  LocalDatabaseImpl.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

final class LocalDatabaseImpl: LocalDatabaseProtocol {
    private let localDb: LocalDataManager
    init() {
        self.localDb = LocalDataManager.shared
    }
    
    func saveWeather(_ weather: Weather) {
        self.localDb.realm.update(item: weather.toStorable())
    }
    
    func deleteWeather(_ weather: Weather) {
        let predicate = NSPredicate(format: "identifier == %@", weather.weatherId)
        self.localDb.realm.remove(where: predicate, type: WeatherStoreable.self)
    }
    
    func getWeather(by cityName: String) -> Weather? {
        let res = self.localDb.realm.getAll(type: WeatherStoreable.self)
        let weather = res.first { stored -> Bool in
            return stored.city?.name?.lowercased() == cityName.lowercased()
        }
        return weather?.toModel()
    }
}
