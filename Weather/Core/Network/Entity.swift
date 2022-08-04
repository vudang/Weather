//
//  Entity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

protocol Entity {
    associatedtype ModelType: Modelable
    func toModel() -> ModelType
}

protocol Modelable {
    associatedtype StoreType: Storable
    func toStorable() -> StoreType
}

protocol Storable {
    associatedtype ModelType: Modelable
    func toModel() -> ModelType
}
