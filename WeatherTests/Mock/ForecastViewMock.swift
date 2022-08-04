//
//  ForecastViewMock.swift
//  WeatherTests
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
@testable import Weather

final class ForecastViewMock: UIViewController, ForecastViewInputs {
    var forecastData: ForecastEntities?
    var errorMessage: String?
    var isLoading: Bool = false
    
    func reloadData(_ data: ForecastEntities) {
        self.forecastData = data
    }
    
    func onError(_ error: String?) {
        self.errorMessage = error
    }
    
    func indicator(animate: Bool) {
        self.isLoading = animate
    }

}
