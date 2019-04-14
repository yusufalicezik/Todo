//
//  Category.swift
//  ToDo
//
//  Created by Yusuf ali cezik on 14.04.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import RealmSwift
class Category:Object{
    @objc dynamic var name:String=""
    @objc dynamic var color:String=""
    let items = List<Item>()
}
