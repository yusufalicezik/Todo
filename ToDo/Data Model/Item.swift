//
//  Item.swift
//  ToDo
//
//  Created by Yusuf ali cezik on 14.04.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool=false
    var parentCategory=LinkingObjects(fromType: Category.self, property: "items")
}
