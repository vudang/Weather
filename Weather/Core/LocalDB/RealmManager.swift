//
//  RealmManager.swift
//  Weather
//
//  Created by Tony on 04/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    private var realm: Realm!
    static let shared = RealmManager()
    
    init() {
        self.realmConfiguration()
    }

    func remove<T: Object>(where predicate: NSPredicate, type: T.Type) {
        let objects = realm
            .objects(type)
            .filter(predicate)
        guard let localItem = objects.first else {
            return
        }
        
        try? realm.write {
            realm.delete(localItem)
        }
    }
    
    func getAll<T: Object>(where predicate: NSPredicate? = nil, type: T.Type) -> [T] {
        var objects = realm.objects(type)

        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        return objects.compactMap{ $0 as T }
    }

    func insert(item: Object) {
        try? realm.write {
            realm.add(item)
        }
    }
    
    func update(item: Object) {
        if self.realm.isInWriteTransaction {
            self.realm.add(item, update: .modified)
        } else {
            try! self.realm.write {
                self.realm.add(item, update: .modified)
            }
        }
    }
}

private extension RealmManager {
    func realmConfiguration() {
        ///Rename default realm file.
        let url = Realm.Configuration().fileURL?
            .deletingLastPathComponent()
            .appendingPathComponent("weather.realm")
        print("Local DB: \(url)")
        
        ///Create default config.
        let defaultConfig = Realm.Configuration(fileURL: url, schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            
        })
        self.realm = try! Realm(configuration: defaultConfig)
    }
}


