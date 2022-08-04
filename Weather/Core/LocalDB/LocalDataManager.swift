//
//  LocalDataManager.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

final class LocalDataManager {
    static let shared = LocalDataManager()
    internal let realm = RealmManager.shared
}
