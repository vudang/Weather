//
//  ListEntities.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct ForecastEntryEntity {
    let forecasts: [Forecast]?
}

struct ForecastEntities {
    let entryEntity: ForecastEntryEntity

    init(entryEntity: ForecastEntryEntity) {
        self.entryEntity = entryEntity
    }
}
