//
//  Presenterable.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

protocol Presenterable {
    //    associatedtype V: Viewable
    //    associatedtype I: Interactorable
    //    associatedtype R: Routerable
    //    associatedtype E: PresenterEntities
    //    var dependencies: (view: V, router: R, interactor: I, entities: E) { get }

    associatedtype I: Interactorable
    associatedtype R: Routerable
    var dependencies: (interactor: I, router: R) { get }
}

