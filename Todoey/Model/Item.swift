//
//  Item.swift
//  Todoey
//
//  Created by Reactive Space on 24/01/2019.
//  Copyright © 2019 Reactive Space. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc var done: Bool = false
    
    //  creating a reverse category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
