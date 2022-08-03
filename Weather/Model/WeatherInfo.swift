//
//  WeatherInfoEntity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

struct WeatherInfo: Modelable {
    let id: Int?
    let main, weatherDescription, icon: String?
}

extension WeatherInfo {
    var iconUrl: String? {
        guard let icon = self.icon else {
            return nil
        }
        
        return "\(Host.resourceHost)/img/wn/\(icon)@2x.png"
    }
}
