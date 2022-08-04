//
//  ListRouter.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import UIKit

struct ForecastRouterInput {
    func view() -> ForecastViewController {
        let view = ForecastViewController()
        let interactor = ForecastInteractor(localDatabase: LocalDatabaseImpl(), remoteRequest: RemoteRequestImpl())
        let presenter = ForecastPresenter(view: view,
                                          interactor: interactor,
                                          routerOutput: ForecastRouterOutput(view))
        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }

    func push(from: Viewable) {
        let view = self.view()
        from.push(view, animated: true)
    }

    func present(from: Viewable) {
        let nav = UINavigationController(rootViewController: view())
        from.present(nav, animated: true)
    }
}

final class ForecastRouterOutput: Routerable {
    private(set) weak var view: Viewable!

    init(_ view: ForecastViewInputs) {
        self.view = view
    }

    func transitionDetail(_ forecast: Forecast) {
        // TODO: show detail 
    }
}


