//
//  RemoteRequestProtocol.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RxSwift

protocol RemoteRequestProtocol {
    func fetchListForecast(for city: String,
                           apiKey: String,
                           noOfDays: Int,
                           unit: String) -> Observable<(WeatherEntity?, AppError?)>
}
