//
//  DatabaseManager.swift
//  PsyPadS
//
//  Created by Roy Li on 12/10/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation


class DatabaseManager: DLDatabaseManager {

    override class func modelFileName() -> String? {
        return "Model.momd"
    }
    override class func storeFileName() -> String? {
        return "Database.sqlite"
    }
    override class func modelNames() -> [Any]? {
        return ["Model1", "Model2", "Model3", "Model4"]
    }
    override class func iCloudContainer() -> String? {
        return nil
    }
    override class func iCloudContentNameKey() -> String? {
        return nil
    }
    
    override class func databaseEmpty() -> Bool {
        return RootEntity.mr_countOfEntities() == 0
    }
    override class func populateDatabase() {
        RootEntity.mr_createEntity()
        self.save()
    }
}
