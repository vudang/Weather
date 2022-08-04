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

protocol ForecastViewInputs: Viewable {
    func reloadData(_ data: ForecastEntities)
    func onError(_ error: String?)
    func indicator(animate: Bool)
}

final class ForecastPresenter {
    internal var entities: ForecastEntities?
    private weak var view: ForecastViewInputs!
    private let interactor: ForecastInteractorProtocol
    private let router: ForecastRouterOutput!

    init(view: ForecastViewInputs,
         interactor: ForecastInteractorProtocol,
         routerOutput: ForecastRouterOutput) {
        self.view = view
        self.interactor = interactor
        self.router = routerOutput
    }
}

extension ForecastPresenter: ForecastViewOutputs {
    func searchWeatherForecast(with keyword: String) {
        interactor.queryWeatherChange(keyword)
    }
    
    func didSelected(_ forecast: Forecast) {
        router.transitionDetail(forecast)
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
