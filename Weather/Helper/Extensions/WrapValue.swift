//
//  WrapValue.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Bool: Defaultable {
    static var defaultValue: Bool { return false }
}

extension Int: Defaultable {
    static var defaultValue: Int { return 0 }
}

extension String: Defaultable {
    static var defaultValue: String { return "" }
}

extension Double: Defaultable {
    static var defaultValue: Double { return 0.0 }
}

extension Optional where Wrapped: Defaultable {
    func unwrapValue(_ value: Wrapped = Wrapped.defaultValue) -> Wrapped {
        return self ?? value
    }
}
