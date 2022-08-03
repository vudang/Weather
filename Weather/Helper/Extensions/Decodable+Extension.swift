//
//  Decodable+Extension.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//


import UIKit

extension Decodable {
    static func toModel(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(self, from: data)
            return result
        } catch let err as NSError {
            throw err
        }
    }
}
