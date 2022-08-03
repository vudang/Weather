//
//  ListInteractor.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import RxSwift
import RxRelay

protocol ForecastInteractorOutputs: AnyObject {
    func onSearchedResult(res: [Forecast])
    func onSearchedError(error: AppError?)
    func showIndicator(_ show: Bool)
}

final class ForecastInteractor: Interactorable {

    weak var presenter: ForecastInteractorOutputs?
    private lazy var disposeBag = DisposeBag()
    private let querySubject = ReplaySubject<String?>.create(bufferSize: 1)
    private var indicatorObserble: Observable<Bool>?
    
    init() {
        self.observerSearching()
        self.observerLoading()
    }

    private func observerSearching() {
        let activityIndicator = ActivityIndicator()
        self.indicatorObserble = activityIndicator.asObservable()
        self.querySubject
            .compactMap { $0 }
            .debounce(RxTimeInterval.milliseconds(500),
                      scheduler: ConcurrentMainScheduler.instance)
            .flatMapLatest {
                Requester.fetchListForecast(for: $0,
                                            apiKey: AppKey.apiKey,
                                            noOfDays: 7,
                                            unit: WeatherUnit.metric.rawValue)
                .observe(on: MainScheduler.instance)
                .trackActivity(activityIndicator)
            }
            .subscribe { [weak self] res in
                if let error = res.1 {
                    self?.presenter?.onSearchedError(error: error)
                } else {
                    let forecasts = res.0?.toModel().forecasts ?? []
                    self?.presenter?.onSearchedResult(res: forecasts)
                }
            } onError: { [weak self] _ in
                self?.presenter?.onSearchedError(error: AppError.unknown)
            }.disposed(by: disposeBag)
    }

    private func observerLoading() {
        self.indicatorObserble?.distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.presenter?.showIndicator(isLoading)
            })
            .disposed(by: disposeBag)
            
    }
    
    func queryWeatherChange(_ keyword: String) {
        self.querySubject.onNext(keyword)
    }
}
