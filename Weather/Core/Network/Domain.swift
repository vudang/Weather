//
//  API.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

public class API: NSObject {
    internal static let domain: String = {
        let path = Host.restHost
        return path
    }()
}
