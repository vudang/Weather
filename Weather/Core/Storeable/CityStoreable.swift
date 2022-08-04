//
//  CityStoreable.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RealmSwift

class CityStoreable: Object {
    @objc dynamic var cityId: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var country: String?
    @objc dynamic var population: Int = 0
    @objc dynamic var timezone: Int = 0
    
    override class func primaryKey() -> String? {
        return "cityId"
    }
}

extension CityStoreable: Storable {
    func toModel() -> City {
        return City(id: cityId,
                    name: name,
                    country: country,
                    timezone: timezone)
    }
}
