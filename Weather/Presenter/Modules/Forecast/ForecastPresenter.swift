//
//  ListPresenter.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RxSwift

typealias ForecastPresenterDependencies = (
    interactor: ForecastInteractor,
    router: ForecastRouterOutput
)

protocol ForecastViewInputs: AnyObject {
    func reloadData(_ data: ForecastEntities)
    func onError(_ error: String?)
    func indicator(animate: Bool)
}

final class ForecastPresenter: Presenterable {
    internal var entities: ForecastEntities?
    private weak var view: ForecastViewInputs!
    let dependencies: ForecastPresenterDependencies
    private var counter: String?

    init(view: ForecastViewInputs,
         dependencies: ForecastPresenterDependencies)
    {
        self.view = view
        self.dependencies = dependencies
    }
}

extension ForecastPresenter: ForecastViewOutputs {
    func searchWeatherForecast(with keyword: String) {
        dependencies.interactor.queryWeatherChange(keyword)
    }
    
    func didSelected(_ forecast: Forecast) {
        dependencies.router.transitionDetail(forecast)
    }
}

extension ForecastPresenter: ForecastInteractorOutputs {
    func onSearchedResult(res: [Forecast]) {
        let entity = ForecastEntryEntity(forecasts: res)
        let data = ForecastEntities(entryEntity: entity)
        view.reloadData(data)
    }

    func onSearchedError(error: AppError?) {
        view.onError(error?.message)
    }
    
    func showIndicator(_ show: Bool) {
        view.indicator(animate: show)
    }
}
