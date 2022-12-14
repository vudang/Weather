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

protocol ForecastInteractorProtocol: Interactorable {
    func queryWeatherChange(_ keyword: String)
    func fetchRemoteWeather(from query: String) -> Observable<(Weather?, AppError?)>
    func getWeatherFromLocalDb(from query: String) -> Observable<Weather?>
}

final class ForecastInteractor: ForecastInteractorProtocol {
    weak var presenter: ForecastInteractorOutputs?
    private let localDatabase: LocalDatabaseProtocol
    private let remoteRequest: RemoteRequestProtocol
    
    private lazy var disposeBag = DisposeBag()
    private let querySubject = ReplaySubject<String?>.create(bufferSize: 1)
    private let activityIndicator = ActivityIndicator()
    
    init(localDatabase: LocalDatabaseProtocol, remoteRequest: RemoteRequestProtocol) {
        self.localDatabase = localDatabase
        self.remoteRequest = remoteRequest
        self.observerSearching()
        self.observerLoading()
    }

    private func observerSearching() {
        self.querySubject
            .compactMap { $0 }
            .debounce(RxTimeInterval.milliseconds(500),
                      scheduler: ConcurrentMainScheduler.instance)
            .flatMapLatest { [weak self] query -> Observable<(Weather?, String)> in
                guard let self = self else { return .empty() }
                return self.getWeatherFromLocalDb(from: query)
                    .map { ($0, query)}
            }
            .flatMapLatest { [weak self] (local, query) -> Observable<(Weather?, AppError?)> in
                guard let self = self else { return .empty() }
                guard let localData = local else {
                    return self.fetchRemoteWeather(from: query)
                }
                return .just((localData, nil))
            }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] res in
                if let error = res.1 {
                    self?.presenter?.onSearchedError(error: error)
                } else {
                    let forecasts = res.0?.forecasts ?? []
                    self?.presenter?.onSearchedResult(res: forecasts)
                    self?.saveWeatherToLocalDb(res.0)
                }
            } onError: { [weak self] _ in
                self?.presenter?.onSearchedError(error: AppError.unknown)
            }.disposed(by: disposeBag)
    }

    private func observerLoading() {
        self.activityIndicator.asObservable()
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.presenter?.showIndicator(isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Presenter handle
extension ForecastInteractor {
    func queryWeatherChange(_ keyword: String) {
        self.querySubject.onNext(keyword)
    }
}

// MARK: - Remote handle
extension ForecastInteractor {
    func fetchRemoteWeather(from query: String) -> Observable<(Weather?, AppError?)> {
        return self.remoteRequest
            .fetchListForecast(for: query,
                               apiKey: AppKey.apiKey,
                               noOfDays: 7,
                               unit: WeatherUnit.metric.rawValue)
            .map {($0.0?.toModel(), $0.1)}
            .trackActivity(self.activityIndicator)
    }
}

// MARK: - Local handle
extension ForecastInteractor {
    func getWeatherFromLocalDb(from query: String) -> Observable<Weather?> {
        guard let weather = self.localDatabase.getWeather(by: query) else {
            return .just(nil)
        }
        
        let dayDuration = 86400
        let dateNow = Int(Date().timeIntervalSince1970) / dayDuration
        let localDate = (weather.forecasts?.first?.dayTime).unwrapValue() / dayDuration
        
        guard dateNow == localDate else {
            self.localDatabase.deleteWeather(weather)
            return .just(nil)
        }
        return .just(weather)
    }
    
    private func saveWeatherToLocalDb(_ weather: Weather?) {
        guard let weather = weather else {
            return
        }
        self.localDatabase.saveWeather(weather)
    }
}
