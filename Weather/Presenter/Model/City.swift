//
//  City.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct City: Modelable {
    let id: Int?
    let name: String?
    let country: String?
    let timezone: Int?
}

extension City {
    func toStorable() -> CityStoreable {
        let store = CityStoreable()
        store.cityId = id.unwrapValue()
        store.name = name
        store.country = country
        store.timezone = timezone.unwrapValue()
        return store
    }
}
