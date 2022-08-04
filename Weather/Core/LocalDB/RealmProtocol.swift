//
//  RealmProtocol.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype EntityObject: Entity
    
    func getAll(where predicate: NSPredicate?) -> [EntityObject]
    func remove(where predicate: NSPredicate)
    func insert(item: EntityObject)
    func update(item: EntityObject)
}

extension Repository {
    func getAll() -> [EntityObject] {
        return getAll(where: nil)
    }
}
