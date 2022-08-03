//
//  Entity.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

public protocol Entity {
    associatedtype ModelType: Modelable
    
    func toModel() -> ModelType
}

public protocol Modelable {}
