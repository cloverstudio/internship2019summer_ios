//
//  RealmManager.swift
//  MojGrad
//
//  Created by Ja on 30/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    let realm = try? Realm()
    
    func deleteDatabase() {
        try! realm?.write({
            realm?.deleteAll()
        })
    }
    
    func deleteObjects(objs: Object) {
        try? realm!.write ({
            realm?.delete(objs)
        })
    }
    
    func saveObjects(objs: Object) {
        try? realm!.write ({
            // If update = false, adds the object, erro je jednako false
            realm?.add(objs, update: .error)
        })
    }
    
    func editObjects(objs: Object) {
        try? realm!.write ({
            realm?.add(objs, update: .all) //pitaj za taj dio
        })
    }
    
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm!.objects(type)
    }
    
    func incrementID() -> Int {
        return (realm!.objects(News.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
