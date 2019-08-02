//
//  News.swift
//  MojGrad
//
//  Created by Ja on 30/07/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import Foundation
import RealmSwift

class News: Object {
    
    @objc dynamic var id = 0 //dynamic omogućuje realm-u da promatra promijene i prilikom korištenja app
    @objc dynamic var context = ""
    @objc dynamic var title = ""
    @objc dynamic var image = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, context: String, title: String, image: String) {
        self.init()
        self.id = id
        self.context = context
        self.title = title
        self.image = image
    }
}
