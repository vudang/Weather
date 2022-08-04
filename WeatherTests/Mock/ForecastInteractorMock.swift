//
//  ForecastInteractorMock.swift
//  WeatherTests
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RxSwift
@testable import Weather

final class ForecastInteractorMock: ForecastInteractorProtocol {
    private lazy var disposeBag = DisposeBag()
    weak var presenter: ForecastInteractorOutputs?
    
    func fetchRemoteWeather(from query: String) -> Observable<(Weather?, AppError?)> {
        let weatherStub = self.stubWeatherRemoteData()
        let cityName = (weatherStub?.city?.name).unwrapValue().lowercased()
        if cityName.contains(query.lowercased()) {
            return .just((weatherStub, nil))
        }
        return .just((nil, .dataNotFound))
    }
    
    func getWeatherFromLocalDb(from query: String) -> Observable<Weather?> {
        let weatherStub = self.stubWeatherLocalData()
        let cityName = (weatherStub?.city?.name).unwrapValue().lowercased()
        if cityName.contains(query.lowercased()) {
            return .just(weatherStub)
        }
        return .just(nil)
    }
    
    func queryWeatherChange(_ query: String) {
        self.getWeatherFromLocalDb(from: query)
            .flatMapLatest { [weak self] local -> Observable<(Weather?, AppError?)> in
                guard let self = self else { return .empty() }
                guard let localData = local else {
                    return self.fetchRemoteWeather(from: query)
                }
                return .just((localData, nil))
            }
            .subscribe { [weak self] res in
                if let error = res.1 {
                    self?.presenter?.onSearchedError(error: error)
                } else {
                    let forecasts = res.0?.forecasts ?? []
                    self?.presenter?.onSearchedResult(res: forecasts)
                }
            } onError: { [weak self] _ in
                self?.presenter?.onSearchedError(error: AppError.unknown)
            }.disposed(by: disposeBag)
    }
    
    private func stubWeatherRemoteData() -> Weather? {
        guard let data = self.getData(for: "WeatherRemote") else {
            return nil
        }
        let entity = try? WeatherEntity.toModel(from: data)
        return entity?.toModel()
    }
    
    private func stubWeatherLocalData() -> Weather? {
        guard let data = self.getData(for: "WeatherDB") else {
            return nil
        }
        let entity = try? WeatherEntity.toModel(from: data)
        return entity?.toModel()
    }
    
    private func getData(for fileName: String) -> Data? {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            return nil
        }
        guard let jsonData = NSData(contentsOfFile: pathString) else {
            return nil
        }
        return Data(referencing: jsonData)
    }
}
