//
//  WeatherTests.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import XCTest
@testable import Weather
import RxSwift

class ForecastPresenterTests: XCTestCase {
    private lazy var disposeBag = DisposeBag()
    var presenter: ForecastPresenter!
    var view = ForecastViewMock()
    var interactor = ForecastInteractorMock()
    
    override func setUp() {
        let router = ForecastRouterOutput(view)
        presenter = ForecastPresenter(view: view,
                                      interactor: interactor,
                                      routerOutput: router)
        interactor.presenter = presenter
    }

    func testRemoteForecast_Success() {
        interactor.fetchRemoteWeather(from: "Ho chi minh")
            .subscribe(onNext: { res in
                XCTAssertNotNil(res.0)
            })
            .disposed(by: disposeBag)
    }
    
    func testRemoteForecast_Nofound() {
        interactor.fetchRemoteWeather(from: "Ha Noi")
            .subscribe(onNext: { res in
                XCTAssertEqual(res.1, AppError.dataNotFound)
            })
            .disposed(by: disposeBag)
    }
    
    func testLocalForecast_Success() {
        interactor.getWeatherFromLocalDb(from: "Kon")
            .subscribe(onNext: { res in
                XCTAssertNotNil(res)
            })
            .disposed(by: disposeBag)
    }
    
    func testLocalForecast_Nofound() {
        interactor.getWeatherFromLocalDb(from: "Ha Noi")
            .subscribe(onNext: { res in
                XCTAssertNil(res)
            })
            .disposed(by: disposeBag)
    }
    
    func testGetWeather_WithLocal_Success() {
        let expectation = self.expectation(description: "Query")
        interactor.queryWeatherChange("Kon")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(view.forecastData)
    }
    
    func testGetWeather_WithRemote_Success() {
        let expectation = self.expectation(description: "Query")
        interactor.queryWeatherChange("Ho Chi")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(view.forecastData)
    }
    
    func testGetWeather_NotFound() {
        let expectation = self.expectation(description: "Query")
        interactor.queryWeatherChange("Ha Noi")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(view.errorMessage)
    }
}
